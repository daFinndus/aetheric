import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/popups/imprint_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/popups/data_privacy_page.dart';
import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/popups/confirm_deletion_page.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:aetheric/elements/custom_field_button_important.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // String _username = 'Nomen Nescio';
  String _imageUrl = '';

  final ScrollController _scrollController = ScrollController();

  double _opacity = 0.75;

  final Auth _auth = Auth();
  final AppFeatures _app = AppFeatures();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    Future.delayed(Duration.zero, () {
      _getData();
    });
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
              const ExperimentalFeaturePage(
                title: 'Edit profile',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: _imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
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
      ),
    );
  }

  _getData() {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    _userColl
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          // _username = documentSnapshot.get('personal_data')['username'];
          _imageUrl = documentSnapshot.get('personal_data')['imageUrl'];
        });
      }
    });

    // Pop the loading dialog
    Navigator.of(context).pop();
  }

  // Function for listening to the scroll position and changing the opacity of the image container
  _scrollListener() {
    debugPrint('Scrolling...');

    setState(() {
      _opacity = 1.0 - _scrollController.offset / 100;
      // Make sure the variable is in our desired range
      _opacity = _opacity.clamp(0.0, 0.75);
    });
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
