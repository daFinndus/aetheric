import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/services/chat/screens/profile_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_icon_button.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/popups/confirm_deletion_page.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:aetheric/elements/custom_icon_button_important.dart';

// Add profile picture, edit profile and more
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();
  final preferences = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 64.0),
            CustomIconButton(
              icon: Icons.person,
              text: 'Edit profile',
              function: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
            CustomIconButton(
              icon: Icons.moving,
              text: 'Toggle marquee - moving text',
              function: () => _toggleMarquee(),
            ),
            const SizedBox(height: 32.0),
            CustomIconButton(
              icon: Icons.help,
              text: 'Support',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
              ),
            ),
            const SizedBox(height: 32.0),
            CustomIconButton(
              icon: Icons.door_back_door_rounded,
              text: 'Sign out',
              function: () => _auth.signOut(),
            ),
            CustomFieldButtonImportant(
              icon: Icons.delete,
              text: 'Delete your account',
              function: () => _showBottomPage(
                context,
                const ConfirmDeletionPage(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // This toggles the marquee bool in the shared preferences
  // It is used for the contact tile in our chat page
  _toggleMarquee() async {
    final prefs = await preferences;
    final marquee = prefs.getBool('marquee') ?? false;

    try {
      await prefs.setBool('marquee', !marquee);
    } catch (e) {
      debugPrint('Error: $e');

      if (mounted) {
        _app.showErrorFlushbar(context, 'Error toggling marquee');
      }
    }

    if (mounted) {
      if (marquee) {
        _app.showErrorFlushbar(context, 'Marquee is now set to ${!marquee}');
      } else {
        _app.showSuccessFlushbar(context, 'Marquee is now set to ${!marquee}');
      }
    }
  }

  // Function for showing a page which appears from the bottom of the screen
  _showBottomPage(BuildContext context, Widget page) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return page;
      },
    );
  }
}
