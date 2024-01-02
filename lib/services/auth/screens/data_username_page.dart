import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 72.0),
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
                  const SizedBox(height: 72.0),
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
          ],
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
    String firstName = '';
    String lastName = '';
    DateTime birthday = DateTime.now();
    String username = '';

    await preferences.then((pref) => {
          firstName = pref.getString('firstName')!,
          lastName = pref.getString('lastName')!,
          birthday = DateTime.parse(pref.getString('birthday')!),
          username = pref.getString('username')!,
        });

    debugPrint(firstName);
    debugPrint(lastName);
    debugPrint(birthday.toString());
    debugPrint(username);

    await _usersColl.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'username': username,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
