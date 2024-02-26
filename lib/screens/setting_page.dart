import 'package:flutter/material.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_icon_button.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/popups/confirm_deletion_page.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:aetheric/elements/custom_icon_button_important.dart';

// TODO: Make this stuff prettier
// Add profile picture, edit profile and more
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();

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
