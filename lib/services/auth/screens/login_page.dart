import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';
import 'package:aetheric/services/auth/model/auth_expections.dart';
import 'package:aetheric/services/auth/elements/auth_text_field.dart';
import 'package:aetheric/services/auth/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Auth _auth = Auth();
  final AuthExceptions _authExceptions = AuthExceptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Aetheric!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Closed Alpha v0.1.0',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 36.0),
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
                        TextButton(
                          onPressed: () => _resetPassword(context),
                          child: Text(
                            'Forgot your password? Click here!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 64.0),
                        AuthButton(
                          text: 'Ready. Set. Go!',
                          function: () => _signIn(
                            context,
                            _emailController.text,
                            _passwordController.text,
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

  // Function for checking if the the given data isn't empty
  bool _checkData(String email, String password) =>
      email.isNotEmpty && password.isNotEmpty;

  Future _signIn(BuildContext context, String email, String password) async {
    // Check if the needed data is entered
    if (!_checkData(email, password)) {
      _showErrorFlushbar(context, 'Please enter your data');
      return;
    }

    try {
      await _auth.signIn(context, email, password);
    } on FirebaseAuthException catch (e) {
      // Only catch auth errors, other errors will be sent to firestore
      // This is done to prevent the user from getting a flushbar for every error
      if (context.mounted) {
        if (e.code == 'user-not-found') {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return RegistrationPage(
                email: email,
                password: password,
              );
            },
          );
        } else {
          if (_authExceptions.errors.containsKey(e.code)) {
            _showErrorFlushbar(context, _authExceptions.errors[e.code]!);
          }
        }
      }
    }
  }

  // Function for resetting the password
  Future _resetPassword(BuildContext context) async {
    String email = _emailController.text;

    if (email.isNotEmpty) {
      try {
        await _auth.resetPassword(context, email);

        // Display a confirmation for the user
        if (context.mounted) {
          _showConfirmationFlushbar(context, 'You should get an email soon!');
        }
      } catch (e) {
        if (context.mounted) _showErrorFlushbar(context, e.toString());
      }
    } else {
      _showErrorFlushbar(context, 'Please enter your email');
    }
  }

  _showConfirmationFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromARGB(204, 31, 136, 31),
    ).show(context);
  }

  _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromRGBO(230, 50, 50, 0.8),
    ).show(context);
  }
}
