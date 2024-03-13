import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as scale;

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/elements/custom_text_button.dart';
import 'package:aetheric/elements/custom_icon_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _imageUrl = '';
  File _image = File('');
  final ImagePicker _picker = ImagePicker();

  late String uid = _auth.currentUser!.uid;

  final AppFeatures _app = AppFeatures();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');
  late final DocumentReference _userDoc = _userColl.doc(uid);

  late final userStream = _userDoc.snapshots();

  @override
  void initState() {
    super.initState();
    // If the application crashes while taking the picture
    _getLostData();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: StreamBuilder(
            stream: _userColl.doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error));
                  } else {
                    return _buildProfileColumn(snapshot.data!);
                  }
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        );
      },
    );
  }

  // In here is our content for the profile page
  _buildProfileColumn(DocumentSnapshot snapshot) {
    return SingleChildScrollView(
      child: SizedBox(
        width: SizerUtil.width,
        height: SizerUtil.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showChoices(context),
              child: Container(
                width: 128.0,
                height: 128.0,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64.0),
                  child: _image.path == ''
                      ? CachedNetworkImage(
                          imageUrl: snapshot['technical_data']['imageUrl'],
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.file(
                          _image,
                          width: 128.0,
                          height: 128.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  CustomTextButton(
                    text: 'Edit Profile Picture',
                    color: Theme.of(context).colorScheme.secondary,
                    function: () => _showChoices(context),
                  ),
                  const SizedBox(height: 32.0),
                  CustomTextField(
                    icon: Icons.person,
                    hintText: 'Edit username',
                    isPassword: false,
                    obscureText: false,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    icon: Icons.person,
                    hintText: 'Edit first name',
                    isPassword: false,
                    obscureText: false,
                    controller: _firstNameController,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    icon: Icons.person,
                    hintText: 'Edit last name',
                    isPassword: false,
                    obscureText: false,
                    controller: _lastNameController,
                  ),
                  const SizedBox(height: 32.0),
                  CustomTextButton(
                    text: 'Confirm changes',
                    color: Theme.of(context).colorScheme.secondary,
                    function: () => _updateData(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    XFile? image;

    try {
      image = await _picker.pickImage(source: source);
    } catch (e) {
      debugPrint('Error: $e');

      if (mounted) {
        _app.showErrorFlushbar(context, 'Error getting image');
      }
    }

    setState(() {
      if (image != null) _image = File(image.path);
      Navigator.of(context).pop();
    });
  }

  // If the application crashes while taking the picture
  // This function will retrieve the lost data
  _getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();

    if (response.isEmpty) return;

    final List<XFile>? files = response.files;

    if (files != null) {
      setState(() {
        _image = File(files.single.path);
        _app.showSuccessFlushbar(context, 'Successfully retrieved lost data');
      });
    }
  }

  // Function for scaling down our image for storage purposes
  Future<File> _scaleImage(File image, int maxSize) async {
    final scale.Image? decodedImage = scale.decodeImage(
      await image.readAsBytes(),
    );

    if (decodedImage == null) {
      return image;
    }

    final scale.Image resizedImage = scale.copyResize(
      decodedImage,
      width: maxSize,
      height: maxSize,
      interpolation: scale.Interpolation.linear,
    );

    // Save the downscaled image to a temporary file
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/scaled_image.jpg');
    await tempFile.writeAsBytes(scale.encodeJpg(resizedImage));

    return tempFile;
  }

  // Function for updating our current picture
  Future _updatePicture() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference picRef = storage.ref('profile_pictures');

    final scaledImage = await _scaleImage(_image, 512);

    await picRef.child(uid).delete();
    await picRef.child(uid).putFile(scaledImage);

    _imageUrl = await picRef.child(uid).getDownloadURL();
    await _userDoc.set({
      'technical_data': {'imageUrl': _imageUrl}
    }, SetOptions(merge: true));
  }

  // Function for updating our personal data
  Future _updateData() async {
    bool dataEdited = false;

    if (_usernameController.text.isNotEmpty) {
      if (_app.checkForWhitespace(_usernameController.text)) {
        dataEdited = true;
        await _userDoc.set({
          'personal_data': {'username': _usernameController.text}
        }, SetOptions(merge: true));
      } else {
        if (mounted) {
          _app.showErrorFlushbar(context, 'Username cannot contain whitespace');
        }
      }
    }

    if (_firstNameController.text.isNotEmpty) {
      dataEdited = true;
      String firstName = _app.capitalizeName(_firstNameController.text);

      await _userDoc.set({
        'personal_data': {'first_name': firstName},
      }, SetOptions(merge: true));
    }

    if (_lastNameController.text.isNotEmpty) {
      dataEdited = true;
      String lastName = _app.capitalizeName(_lastNameController.text);

      await _userDoc.set({
        'personal_data': {'last_name': lastName}
      }, SetOptions(merge: true));
    }

    if (_image.path.isNotEmpty) {
      dataEdited = true;
      await _updatePicture();
    }

    if (mounted) {
      if (dataEdited) {
        _app.showSuccessFlushbar(context, 'Successfully updated your data');
      } else {
        _app.showErrorFlushbar(context, 'No data to update');
      }
    }
  }

  // Function for showing a modal bottom sheet with a choice of pick image sources
  _showChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: SizerUtil.width,
        height: SizerUtil.height * 0.225,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomIconButton(
              icon: Icons.camera,
              text: 'Make a picture',
              function: () => _getImage(ImageSource.camera),
            ),
            CustomIconButton(
              icon: Icons.photo,
              text: 'Search through gallery',
              function: () => _getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
