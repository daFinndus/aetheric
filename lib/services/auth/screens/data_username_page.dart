import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/elements/custom_text_button.dart';
import 'package:aetheric/services/auth/screens/data_picture_page.dart';

class DataUsernamePage extends StatefulWidget {
  const DataUsernamePage({super.key});

  @override
  State<DataUsernamePage> createState() => _DataUsernamePageState();
}

class _DataUsernamePageState extends State<DataUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();

  final preferences = SharedPreferences.getInstance();

  final AppFeatures _app = AppFeatures();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: SizedBox(
                width: SizerUtil.width,
                height: SizerUtil.height,
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
                          CustomTextField(
                            icon: Icons.person,
                            hintText: 'Username',
                            isPassword: false,
                            obscureText: false,
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 64.0),
                          CustomTextButton(
                            text: "Let's head to the last step",
                            function: () => _saveDataAndNavigate(context),
                            color: Theme.of(context).colorScheme.onPrimary,
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
      },
    );
  }

  bool _checkData(String username) {
    if (username.isNotEmpty) {
      return true;
    }
    return false;
  }

  // Save the data to local storage, then read out all and upload to Firestore
  _saveDataAndNavigate(BuildContext context) async {
    String username = _usernameController.text;

    if (!_checkData(username)) {
      _app.showErrorFlushbar(context, 'Please fill in all fields');
      return;
    }

    if (_app.checkForWhitespace(username)) {
      _app.showErrorFlushbar(context, 'Username cannot contain whitespace');
      return;
    }

    await preferences.then((pref) => {
          pref.setString('username', username),
        });

    context.mounted
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DataPicturePage()),
          )
        : const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
  }
}
