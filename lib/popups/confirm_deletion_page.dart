import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:slide_to_act/slide_to_act.dart';

import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/screens/login_page.dart';

class ConfirmDeletionPage extends StatefulWidget {
  const ConfirmDeletionPage({super.key});

  @override
  State<ConfirmDeletionPage> createState() => _ConfirmDeletionPageState();
}

class _ConfirmDeletionPageState extends State<ConfirmDeletionPage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            Text(
              'Think twice before this.',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              'Everything related to you, will be deleted.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 32.0,
                left: 64.0,
                right: 64.0,
              ),
              child: SlideAction(
                text: 'Slide to delete',
                textColor: Colors.white,
                innerColor: Colors.red,
                outerColor: Colors.redAccent,
                sliderButtonIcon: const Icon(Icons.delete, color: Colors.white),
                submittedIcon: const Icon(Icons.check, color: Colors.white),
                onSubmit: () => _deleteAccount(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIXME: Error doesnt get rethrown in auth.dart, how can I fix that?
  _deleteAccount() {
    try {
      _auth.deleteAccount(context);
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('TESTTESTESTESTESTTESTES');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please sign in again'),
            content: const Text(
              'For security reasons, please sign in again to delete your account.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
