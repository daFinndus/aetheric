import 'package:flutter/material.dart';

import 'package:aetheric/elements/custom_text_button.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const SizedBox(height: 128.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'I am a user already',
                      function: () => {},
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    CustomButton(
                      text: 'I am new here',
                      function: () => {},
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
