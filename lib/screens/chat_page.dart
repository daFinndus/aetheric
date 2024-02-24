import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/popups/experimental_feature_page.dart';
import 'package:aetheric/services/chat/elements/contact_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AppFeatures _app = AppFeatures();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Search for contacts, add someone and more',
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreSettings(context),
          ),
        ],
      ),
      body: _buildContactList(),
    );
  }

  _generateChatId(String currentId, String otherId) {
    final List<String> uids = [currentId, otherId];
    uids.sort();
    return uids.join('');
  }

  // Build the entire contact list
  _buildContactList() {
    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data available...'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((document) => _buildContactListItem(document))
                .toList(),
          );
        }
      },
    );
  }

  // Build each contact list item
  _buildContactListItem(DocumentSnapshot document) {
    final String uid = _firebaseAuth.currentUser!.uid;
    final String chatId = _generateChatId(uid, document.id);

    if (uid == document.id) {
      return const SizedBox();
    } else {
      return ContactTile(
        data: document,
        receiverUid: document.id,
        chatId: chatId,
      );
    }
  }

  // Function for showing a modal bottom sheet with certain features
  _showMoreSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomFieldButton(
              icon: Icons.search_rounded,
              text: 'Search through your contacts',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
              ),
            ),
            CustomFieldButton(
              icon: Icons.add,
              text: 'Add a contact',
              function: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
