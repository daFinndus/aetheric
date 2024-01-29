import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:slide_to_act/slide_to_act.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/screens/login_page.dart';

class ConfirmDeletionPage extends StatefulWidget {
  const ConfirmDeletionPage({super.key});

  @override
  State<ConfirmDeletionPage> createState() => _ConfirmDeletionPageState();
}

class _ConfirmDeletionPageState extends State<ConfirmDeletionPage> {
  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();

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
            Container(
              margin: const EdgeInsets.only(top: 32.0, left: 58.0, right: 58.0),
              child: SlideAction(
                text: 'Slide to delete',
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textColor: Colors.white,
                innerColor: Colors.red,
                outerColor: Colors.redAccent,
                sliderButtonIcon: const Icon(Icons.delete, color: Colors.white),
                submittedIcon: const Icon(Icons.check, color: Colors.white),
                onSubmit: () => _deleteAccount(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function for deleting the account
  // TODO: Fix this function, the error is not being catched in the confirm_deletion_page after rethrowing it
  _deleteAccount(BuildContext context) {
    try {
      _auth.deleteAccount();
    } catch (e) {
      if (e is FirebaseAuthException) {
        debugPrint('Error was caught, showing dialog...');
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
      } else {
        debugPrint("Error was caught: ${e.toString()}");
        _app.showErrorFlushbar(context, e.toString());
      }
    }
  }
}
