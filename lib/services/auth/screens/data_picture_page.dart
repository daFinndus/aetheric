import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as scale;

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/screens/tab_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_icon_button.dart';
import 'package:aetheric/elements/custom_text_button.dart';

// Class for the user to upload a profile picture
class DataPicturePage extends StatefulWidget {
  const DataPicturePage({super.key});

  @override
  State<DataPicturePage> createState() => _DataPicturePageState();
}

class _DataPicturePageState extends State<DataPicturePage> {
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  DateTime _birthday = DateTime.now();

  String _imageUrl = '';
  File _image = File('');
  final ImagePicker _picker = ImagePicker();

  final preferences = SharedPreferences.getInstance();
  final AppFeatures _app = AppFeatures();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');

  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final Reference _picRef = _storage.ref('profile_pictures');

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
          body: SingleChildScrollView(
            child: SizedBox(
              width: SizerUtil.width,
              height: SizerUtil.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Last but not least',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Show us your smile',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 64.0),
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
                            ? Icon(
                                Icons.lens_blur,
                                size: 64.0,
                                color: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(height: 64.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        CustomTextButton(
                          text: 'Choose a picture',
                          function: () => _showChoices(context),
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        CustomTextButton(
                          text: 'Finish registration',
                          function: () => _uploadPicture(),
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function for selecting an image from the device
  Future<void> _getImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);

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
      });
    }
  }

  // Function for uploading our image to the firebase storage
  Future _uploadPicture() async {
    if (_image.path == '') {
      _app.showErrorFlushbar(context, 'Please provide a picture');
      return;
    }

    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    final scaledImage = await _scaleImage(_image, 512);
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // Upload the picture and get the URL
    await _picRef.child(uid).putFile(scaledImage);
    _imageUrl = await _picRef.child(uid).getDownloadURL();

    await preferences.then((pref) => {
          pref.setString('profile_picture', _imageUrl),
        });

    _uploadData();

    // Pop the loading dialog
    if (mounted) Navigator.of(context).pop();
  }

  // Function for scaling down the image to a certain size
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

  // Function for uploading all necessary data to Firestore
  // And routing to the tab page afterwards
  Future _uploadData() async {
    await preferences
        .then((pref) => {
              _firstName = pref.getString('firstName')!,
              _lastName = pref.getString('lastName')!,
              _username = pref.getString('username')!,
              _birthday = DateTime.parse(pref.getString('birthday')!),
            })
        .whenComplete(() => preferences.then((pref) {
              pref.remove('firstName');
              pref.remove('lastName');
              pref.remove('username');
              pref.remove('birthday');
            }));

    debugPrint('Uploading data to Firestore...');

    await _userColl.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'personal_data': {
        'firstName': _firstName,
        'lastName': _lastName,
        'birthday': _birthday,
        'username': _username,
      },
      'technical_data': {
        'email': FirebaseAuth.instance.currentUser!.email,
        'imageUrl': _imageUrl,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      },
    });

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const TabPage()),
      );
    }
  }

  // Function for showing a modal bottom sheet with a choice of pick image sources
  _showChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: SizerUtil.width,
        height: SizerUtil.height * 0.1,
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
