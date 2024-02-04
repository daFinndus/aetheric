import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';
import 'package:aetheric/services/auth/model/auth_expections.dart';
import 'package:aetheric/services/auth/elements/auth_text_field.dart';
import 'package:aetheric/services/auth/screens/data_personal_name_page.dart';

class RegistrationPage extends StatefulWidget {
  final String email;
  final String password;

  const RegistrationPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cfrmPasswordController = TextEditingController();

  final AppFeatures _app = AppFeatures();

  final Auth _auth = Auth();
  final AuthExceptions _authExceptions = AuthExceptions();

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.email;
    _passwordController.text = widget.password;
  }

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
                    'Welcome to Aetheric!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'The easy way to message your friends.',
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
                          icon: Icons.email,
                          hintText: 'Enter your email',
                          isPassword: false,
                          obscureText: false,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 8.0),
                        AuthTextField(
                          icon: Icons.lock,
                          hintText: 'Enter your password',
                          isPassword: true,
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 8.0),
                        AuthTextField(
                          icon: Icons.lock,
                          hintText: 'Confirm your password',
                          isPassword: true,
                          obscureText: true,
                          controller: _cfrmPasswordController,
                        ),
                        const SizedBox(height: 64.0),
                        AuthButton(
                          text: 'Start your journey',
                          function: () => _signUp(
                            context,
                            _emailController.text,
                            _passwordController.text,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Already a user? Go back here.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
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

  // Check if the password is valid
  bool _checkPassword() {
    if (_passwordController.text.length > 5) {
      if (_passwordController.text == _cfrmPasswordController.text) {
        return true;
      } else {
        _app.showErrorFlushbar(context, 'Passwords do not match');
        return false;
      }
    } else {
      _app.showErrorFlushbar(context, 'Password is too short');
      return false;
    }
  }

  // Function for signing up the user
  Future _signUp(BuildContext context, String email, String password) async {
    // Check if the password is long enough and if the passwords match
    if (!_checkPassword()) return;

    try {
      // Trying to sign up the user via firebase auth
      await _auth.signUp(email, password);

      if (context.mounted) Navigator.of(context).pop();

      // Route to the personal data page
      if (context.mounted) {
        _app.showBottomSheet(context, const DataPersonalNamePage());
      }
    } on FirebaseAuthException catch (e) {
      // Only catch auth errors, other errors will be sent to firestore
      // This is done to prevent the user from getting a flushbar for every error
      if (context.mounted) {
        if (_authExceptions.errors.containsKey(e.code)) {
          _app.showErrorFlushbar(context, _authExceptions.errors[e.code]!);
        }
      }
    }
  }
}
