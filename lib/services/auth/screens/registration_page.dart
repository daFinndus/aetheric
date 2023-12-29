import 'package:flutter/material.dart';

import 'package:aetheric/services/auth/functions/auth.dart';

import 'package:another_flushbar/flushbar.dart';

import 'package:aetheric/services/auth/elements/auth_text_field.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';

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

  final Auth _auth = Auth();

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
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Whoops!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Seems like you are not a user yet.',
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
                        text: 'Start your journey.',
                        function: () => _signUp(
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
        _showErrorFlushbar(context, 'Passwords do not match');
        return false;
      }
    } else {
      _showErrorFlushbar(context, 'Password is too short');
      return false;
    }
  }

  // Function for signing up the user
  Future _signUp(BuildContext context, String email, String password) async {
    if (!_checkPassword()) {
      return;
    }
    // Trying to sign up the user via firebase auth
    await _auth.signUp(context, email, password);

    if (context.mounted) {
      Navigator.pop(context);
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
