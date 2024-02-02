import 'package:aetheric/popups/confirm_deletion_page.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:flutter/material.dart';

import 'package:aetheric/popups/imprint_page.dart';
import 'package:aetheric/popups/data_privacy_page.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/elements/custom_field_button_important.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => debugPrint('Pressed button on settings page'),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        children: [
          CustomFieldButton(
            icon: Icons.abc,
            text: 'Placeholder',
            function: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(
                title: 'Placeholder',
              ),
            ),
          ),
          CustomFieldButton(
            icon: Icons.language,
            text: 'Change language',
            function: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(
                title: 'Change language',
              ),
            ),
          ),
          CustomFieldButton(
            icon: Icons.notifications,
            text: 'En- or disable notifications',
            function: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(
                title: 'En- or disable notifications',
              ),
            ),
          ),
          CustomFieldButton(
            icon: Icons.color_lens,
            text: 'Change appearance',
            function: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(
                title: 'Change appearance',
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          CustomFieldButton(
            icon: Icons.lock,
            text: 'Data privacy',
            function: () => _showBottomPage(
              context,
              const DataPrivacyPage(),
            ),
          ),
          CustomFieldButton(
            icon: Icons.book,
            text: 'Imprint',
            function: () => _showBottomPage(
              context,
              const ImprintPage(),
            ),
          ),
          CustomFieldButton(
            icon: Icons.help,
            text: 'Support',
            function: () => _app.showBottomSheet(
              context,
              const ExperimentalFeaturePage(
                title: 'Support',
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          CustomFieldButton(
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
