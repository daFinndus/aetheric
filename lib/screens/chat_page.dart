import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/popups/invite_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/popups/add_contact_page.dart';
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
        leading: IconButton(
          tooltip: 'Manage your invites',
          icon: const Icon(Icons.mail),
          onPressed: () => _app.showBottomSheet(
            context,
            const InvitePage(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search for contacts, add someone and more',
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () => _app.showBottomSheet(
              context,
              const AddContactPage(),
            ),
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
      builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.data != null) {
          if (!querySnapshot.hasData) {
            _buildNoContactsYet();
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: querySnapshot.data!.docs
                  .map<Widget>((document) => _buildContactListItem(document))
                  .toList(),
            );
          }
        }
        return _buildNoContactsYet();
      },
    );
  }

  // TODO: Change this so we could use the contact collection snapshot
  // Build each contact list item
  _buildContactListItem(DocumentSnapshot document) {
    final contacts = document.data() as Map<String, dynamic>;
    final receiverUid = contacts['uid']!;
    final chatId = _generateChatId(uid, receiverUid);

    return ContactTile(
      data: document,
      receiverUid: receiverUid,
      chatId: chatId,
    );
  }

  // Function for displaying widgets when there are no contacts
  _buildNoContactsYet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No contacts yet 😢\n',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'Try adding someone by clicking\nthe button in the top right corner.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
