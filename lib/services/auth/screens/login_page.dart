import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/elements/custom_text_button.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/model/auth_expections.dart';
import 'package:aetheric/services/auth/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final preferences = SharedPreferences.getInstance();

  final AppFeatures _app = AppFeatures();

  final Auth _auth = Auth();
  final AuthExceptions _authExceptions = AuthExceptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 156.0),
                Text(
                  'Nice to see you again.',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "We've been waiting for you.",
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
                        icon: Icons.email,
                        hintText: 'Enter your email',
                        isPassword: false,
                        obscureText: false,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        icon: Icons.lock,
                        hintText: 'Enter your password',
                        isPassword: true,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      TextButton(
                        onPressed: () => _resetPassword(context),
                        child: Text(
                          'Forgot your password? Click here!',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 64.0),
                      CustomTextButton(
                        text: 'Ready. Set. Go!',
                        function: () => _signIn(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      TextButton(
                        onPressed: () => _app.showBottomSheet(
                          context,
                          RegistrationPage(
                            email: _emailController.text.isNotEmpty
                                ? _emailController.text
                                : '',
                            password: _passwordController.text.isNotEmpty
                                ? _passwordController.text
                                : '',
                          ),
                        ),
                        child: Text(
                          'Not a user yet? Sign up here.',
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
        ),
      ),
    );
  }

  // Function for checking if the the given data isn't empty
  bool _checkData(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future _signIn(BuildContext context, String email, String password) async {
    // Check if the needed data is entered
    if (!_checkData(email, password)) {
      _app.showErrorFlushbar(context, 'Please enter your data');
      return;
    }

    try {
      await _auth.signIn(email, password);
      if (context.mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // Only catch auth errors, other errors will be sent to firestore in our auth.dart
      // This is done to prevent the user from getting a flushbar for every error
      if (context.mounted) {
        if (_authExceptions.errors.containsKey(e.code)) {
          _app.showErrorFlushbar(
            context,
            _authExceptions.errors[e.code]!,
          );
        } else {
          _app.showErrorFlushbar(context, e.code);
        }
      }
    }
  }

  // Function for resetting the password
  Future _resetPassword(BuildContext context) async {
    String email = _emailController.text;

    if (email.isNotEmpty) {
      try {
        await _auth.resetPassword(email);

        if (context.mounted) {
          _app.showSuccessFlushbar(context, 'You should get an email soon');
        }
      } catch (e) {
        if (context.mounted) _app.showErrorFlushbar(context, e.toString());
      }
    } else {
      _app.showErrorFlushbar(context, 'Please enter your email');
    }
  }
}
