import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/screens/tab_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';
import 'package:aetheric/services/auth/elements/auth_text_field.dart';

class DataUsernamePage extends StatefulWidget {
  const DataUsernamePage({super.key});

  @override
  State<DataUsernamePage> createState() => _DataUsernamePageState();
}

class _DataUsernamePageState extends State<DataUsernamePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersColl = _firestore.collection('users');

  final preferences = SharedPreferences.getInstance();

  final TextEditingController _usernameController = TextEditingController();

  final AppFeatures _app = AppFeatures();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'How should we call you?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'The username will be your identity',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 64.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      AuthTextField(
                        icon: Icons.person,
                        hintText: 'Username',
                        isPassword: false,
                        obscureText: false,
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 64.0),
                      AuthButton(
                        text: 'Finish registration',
                        function: () => _saveDataAndFinish(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Save the data to local storage, then read out all and upload to Firestore
  _saveDataAndFinish(BuildContext context) async {
    try {
      final username = _usernameController.text;

      await preferences.then((pref) => pref.setString('username', username));
      await _uploadData();
    } catch (e) {
      if (context.mounted) _app.showErrorFlushbar(context, e.toString());
    }
  }

  Future _uploadData() async {
    String email = '';
    String password = '';
    String firstName = '';
    String lastName = '';
    DateTime birthday = DateTime.now();
    String username = '';

    await preferences.then((pref) => {
          email = pref.getString('email')!,
          password = pref.getString('password')!,
          firstName = pref.getString('firstName')!,
          lastName = pref.getString('lastName')!,
          username = pref.getString('username')!,
          birthday = DateTime.parse(pref.getString('birthday')!),
        });

    debugPrint('Uploading data to Firestore...');

    await _usersColl.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'personal data': {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'birthday': birthday,
        'username': username,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      }
    });

    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const TabPage()),
      );
    }
  }
}
