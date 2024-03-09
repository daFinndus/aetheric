import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:slide_to_act/slide_to_act.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/popups/refresh_login_alert_page.dart';
import 'package:aetheric/services/auth/screens/login_page.dart';

// This is a widget used in the settings page for deleting the whole account
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          width: SizerUtil.width,
          height: SizerUtil.height * 0.25,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
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
                  margin:
                      const EdgeInsets.only(top: 32.0, left: 58.0, right: 58.0),
                  child: SlideAction(
                    text: 'Slide to delete',
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textColor: Colors.white,
                    innerColor: Colors.red,
                    outerColor: Colors.redAccent,
                    sliderButtonIcon:
                        const Icon(Icons.delete, color: Colors.white),
                    submittedIcon: const Icon(Icons.check, color: Colors.white),
                    onSubmit: () => _deleteAccount(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function for deleting the account
  _deleteAccount(BuildContext context) async {
    try {
      await _auth.deleteAccount();
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        MaterialPageRoute(builder: (context) => const LoginPage());
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        debugPrint('Error was caught, showing dialog...');
        // Pop the bottom bar and show the refresh login alert page
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          _app.showBottomSheet(context, const RefreshLoginAlertPage());
        }
      } else {
        debugPrint("Error was caught: ${e.toString()}");
        if (context.mounted) {
          _app.showErrorFlushbar(context, 'Oh no, an error occured');
        }
      }
    }
  }
}
