import 'package:aetheric/popups/data_privacy_page.dart';
import 'package:aetheric/popups/imprint_page.dart';
import 'package:flutter/material.dart';

import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/elements/custom_field_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Change the app on your needs.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
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
            icon: Icons.door_back_door_rounded,
            text: 'Sign out',
            function: () => _auth.signOut(context),
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
