import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';
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
  bool _checkData(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      _showErrorFlushbar(context, 'Please enter your data');
      return false;
    }
  }

  Future _signIn(BuildContext context, String email, String password) async {
    // Check if the needed data is entered
    if (!_checkData(email, password)) return;

    try {
      // Trying to sign in the user via firebase auth
      await _auth.signIn(context, email, password);
    } catch (e) {
      if (context.mounted && e == 'user-not-registered') {
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
      }
    }
  }

  // This is way cooler than the snackbar
  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromRGBO(230, 50, 50, 0.8),
    ).show(context);
  }
}
