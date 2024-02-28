import 'package:aetheric/popups/add_contact_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_icon_button.dart';
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

  late String uid = _firebaseAuth.currentUser!.uid;
  late DocumentReference userRef = _firestore.collection('users').doc(uid);
  late CollectionReference contactRef = userRef.collection('contacts');

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
      stream: userRef.collection('contacts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data!.size == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No contacts yet.. 😢\n',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Try adding someone by clicking\nthe button in the top right corner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((snapshot) => _buildContactListItem(snapshot))
                  .toList(),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // Build each contact list item
  // TODO: Check if this works
  _buildContactListItem(DocumentSnapshot snapshot) {
    final contacts = snapshot.data() as Map<String, dynamic>;
    final receiverUid = contacts['uid']!;
    final chatId = _generateChatId(uid, receiverUid);

    return ContactTile(
      data: snapshot,
      receiverUid: receiverUid,
      chatId: chatId,
    );
  }

// Function for showing a modal bottom sheet with certain features
  _showMoreSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
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
            CustomIconButton(
              icon: Icons.search_rounded,
              text: 'Search through your contacts',
              function: () => _app.showBottomSheet(
                context,
                const ExperimentalFeaturePage(),
              ),
            ),
            CustomIconButton(
              icon: Icons.add,
              text: 'Add a contact',
              function: () => _app.showBottomSheet(
                context,
                const AddContactPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
