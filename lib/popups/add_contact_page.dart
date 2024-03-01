import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/services/chat/elements/user_tile.dart';

// This page is for the user to send invites to other users
class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController controller = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef = _firestore.collection('users');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          CustomTextField(
            icon: Icons.search,
            hintText: 'Search a contact by username',
            isPassword: false,
            obscureText: false,
            controller: controller,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  // TODO: Sort user list depending on the search query
  // Build user list from the database with user tiles
  _buildUserList() {
    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(
            child: Text('No data available...'),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: userSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = userSnapshot.data!.docs[index];

              return FutureBuilder(
                future: _checkInvitations(document.id),
                builder: (context, AsyncSnapshot<bool> invSnapshot) {
                  if (invSnapshot.data!) {
                    return const SizedBox();
                  } else {
                    return _buildUserListItem(document);
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  // Build user tiles for each user in the database
  // Also check if the user already has a pending invite
  _buildUserListItem(DocumentSnapshot document) {
    debugPrint('Now trying to build user list item for ${document.id}');

    final uid = _auth.currentUser!.uid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);

    final CollectionReference invSentRef = userDoc.collection('invite_sent');
    final CollectionReference invRecvRef = userDoc.collection('invite_recv');

    // Check if we are the user the system is currently iterating
    if (document.id == uid) return const SizedBox();

    // Check if we already sent an invite to the user
    invSentRef.doc(document.id).get().then((doc) {
      if (doc.exists) {
        debugPrint('Invite already sent to ${document.id}');
        return const SizedBox();
      }
    });

    // Check if we already received an invite from the user
    invRecvRef.doc(document.id).get().then((doc) {
      if (doc.exists) {
        debugPrint('Invite already received from ${document.id}');
        return const SizedBox();
      }
    });

    // If nothing of the above is true, return the user tile
    return UserTile(
      data: document,
      function: () => manageInvites(uid, document.id, document),
      userUid: document.id,
      icon: Icons.person_add,
    );
  }

  // This function checks if the user already has a pending or sent invitation
  // This was carried by ChatGPT - thank you very much!
  Future<bool> _checkInvitations(String userId) async {
    final uid = _auth.currentUser!.uid;
    final invSentRef = userRef.doc(uid).collection('invite_sent');
    final invRecvRef = userRef.doc(uid).collection('invite_recv');

    final sentDoc = await invSentRef.doc(userId).get();
    final recvDoc = await invRecvRef.doc(userId).get();

    if (userId == uid) return true;

    return sentDoc.exists || recvDoc.exists;
  }

  // Executes all necessary functions
  manageInvites(String ownUid, String otherUid, DocumentSnapshot document) {
    debugPrint('Sending invite...');
    sendInvite(ownUid, otherUid);
    receiveInvite(otherUid);
    debugPrint('Invite sent!');
  }

  // Send a invite to a certain user
  // Basically add our uid to our invite_send collection
  sendInvite(String uid, String otherUid) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference invSentRef = userDoc.collection('invite_sent');

    invSentRef.doc(otherUid).set({
      'exists': true,
    });
  }

  // Receive an invite from a certain user
  // Basically add the user's uid to our invite_recv collection
  receiveInvite(String uid) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference invSentRef = userDoc.collection('invite_recv');

    invSentRef.doc(_auth.currentUser?.uid).set({
      'exists': true,
    });
  }
}
