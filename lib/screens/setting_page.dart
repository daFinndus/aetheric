import 'package:aetheric/popups/send_feedback_page.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/app/notifications.dart';
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
  final preferences = SharedPreferences.getInstance();

  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();
  final NotificationService _notification = NotificationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomIconButton(
              icon: Icons.notifications,
              text: 'Trigger notification',
              function: () => _notification.showNotification(
                title: 'Hello world',
                body: 'This is a test notification',
              ),
            ),
            CustomIconButton(
              icon: Icons.moving,
              text: 'Toggle marquee',
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
            CustomIconButton(
              icon: Icons.feedback,
              text: 'Send feedback',
              function: () => _app.showBottomSheet(
                context,
                const SendFeedbackPage(),
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

  _toggleMarquee() async {
    final prefs = await preferences;
    final marquee = prefs.getBool('marquee') ?? false;

    await prefs.setBool('marquee', !marquee);

    if (context.mounted) {
      _app.showSuccessFlushbar(context, 'Marquee is now set to ${!marquee}');
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
