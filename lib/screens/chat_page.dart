import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/services/chat/elements/contact_tile.dart';

// TODO: Loading indicator while data is being fetched with a 1s delay

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available...'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: (snapshot.data?.docs.length),
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];

                // Check for user documents, if not our own, create a ContactTile
                if (document.id != _firebaseAuth.currentUser!.uid) {
                  // Create a chatId by sorting the uids and joining them
                  final String chatId = _generateChatId(
                    _firebaseAuth.currentUser!.uid,
                    document.id,
                  );

                  debugPrint('Generated ChatId: $chatId');

                  return ContactTile(
                    receiverId: document.id,
                    chatId: chatId,
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }

  _generateChatId(String currentId, String otherId) {
    final List<String> uids = [currentId, otherId];
    uids.sort();
    return uids.join('');
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
              function: () => {},
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
