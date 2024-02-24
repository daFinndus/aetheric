import 'package:flutter/material.dart';

import 'package:aetheric/popups/imprint_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/popups/data_privacy_page.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/popups/confirm_deletion_page.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:aetheric/elements/custom_field_button_important.dart';

// TODO: Make this stuff prettier
// Add profile picture, edit profile and more
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ScrollController _scrollController = ScrollController();

  double _opacity = 0.75;

  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            CustomFieldButton(
              icon: Icons.language,
              text: 'Change language',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
              ),
            ),
            CustomFieldButton(
              icon: Icons.notifications,
              text: 'En- or disable notifications',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
              ),
            ),
            CustomFieldButton(
              icon: Icons.color_lens,
              text: 'Change appearance',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
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
                const ExperimentalFeaturePage(),
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
      ),
    );
  }

  // Function for listening to the scroll position and changing the opacity of the image container
  _scrollListener() {
    debugPrint('Scrolling...');

    setState(() {
      _opacity = 1.0 - _scrollController.offset / 100;
      // Make sure the variable is in our desired range
      _opacity = _opacity.clamp(0.0, 0.75);
    });

    debugPrint('Offset: ${_scrollController.offset}');
    debugPrint('Opacity: $_opacity');
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
