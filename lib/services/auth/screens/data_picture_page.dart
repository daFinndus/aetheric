import 'dart:io';
import 'package:aetheric/services/auth/elements/auth_button.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/screens/tab_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_field_button.dart';

// Class for the user to upload a profile picture
// This does work
class DataPicturePage extends StatefulWidget {
  const DataPicturePage({super.key});

  @override
  State<DataPicturePage> createState() => _DataPicturePageState();
}

class _DataPicturePageState extends State<DataPicturePage> {
  String _firstName = '';
  String _lastName = '';
  DateTime _birthday = DateTime.now();
  String _username = '';

  File _image = File('');
  String _imageUrl = '';
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
    // FIXME: Function hasn't been implemented yet
    _getLostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                      AuthButton(
                        text: 'Choose a picture',
                        function: () => _showChoices(context),
                      ),
                      AuthButton(
                        text: 'Finish registration',
                        function: () => _uploadPicture(),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
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

    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // Upload the picture and get the URL
    await _picRef.child(uid).putFile(_image);
    _imageUrl = await _picRef.child(uid).getDownloadURL();

    await preferences.then((pref) => {
          pref.setString('profile_picture', _imageUrl),
        });

    _uploadData();

    // Pop the loading dialog
    if (context.mounted) Navigator.of(context).pop();
  }

  // Function for uploading all necessary data to Firestore
  // And routing to the tab page afterwards
  Future _uploadData() async {
    await preferences.then((pref) => {
          _firstName = pref.getString('firstName') ?? 'Nomen',
          _lastName = pref.getString('lastName') ?? 'Nescio',
          _username = pref.getString('username') ?? 'NNescio',
          _birthday =
              DateTime.parse(pref.getString('birthday') ?? '1970-01-01'),
        });

    debugPrint('Uploading data to Firestore...');

    await _userColl.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'personal_data': {
        'firstName': _firstName,
        'lastName': _lastName,
        'birthday': _birthday,
        'username': _username,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profile_picture': _imageUrl,
      }
    });

    if (context.mounted) {
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.225,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomFieldButton(
              icon: Icons.camera,
              text: 'Make a picture',
              function: () => _getImage(ImageSource.camera),
            ),
            CustomFieldButton(
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
