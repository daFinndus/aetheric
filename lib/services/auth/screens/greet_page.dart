import 'package:flutter/material.dart';

import 'package:aetheric/elements/custom_text_button.dart';
import 'package:aetheric/services/auth/screens/login_page.dart';
import 'package:aetheric/services/auth/screens/registration_page.dart';

class GreetPage extends StatelessWidget {
  const GreetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 76.0),
              Icon(
                Icons.lens_blur,
                size: 64.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Welcome to Aetheric.',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "Your smart carrier pigeon.",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 76.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'I am a user already',
                      function: () => _routePage(
                        context,
                        const LoginPage(),
                      ),
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    CustomButton(
                      text: 'I am new here',
                      function: () => _routePage(
                        context,
                        const RegistrationPage(email: '', password: ''),
                      ),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 76.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Text(
                              'Powered by',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/firebase.png',
                                  scale: 16.0,
                                ),
                                const SizedBox(width: 24.0),
                                Image.asset(
                                  'assets/images/google.png',
                                  scale: 16.0,
                                ),
                                const SizedBox(width: 24.0),
                                Image.asset(
                                  'assets/images/flutter.png',
                                  scale: 16.0,
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  _routePage(BuildContext context, Widget page) {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }
}