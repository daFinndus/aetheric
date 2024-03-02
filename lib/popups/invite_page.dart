import 'package:aetheric/services/chat/elements/accept_invite_tile.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/chat/elements/add_user_tile.dart';

// FIXME: This page doesn't work yet, fix it
class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final uid = _auth.currentUser!.uid;

  late CollectionReference userRef = _firestore.collection('users');
  late DocumentReference userDoc = userRef.doc(uid);
  late CollectionReference invRef = userDoc.collection('invite_recv');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: _buildInviteList(),
    );
  }

  // Build the invite list based on our database
  // We only need to listen to the invite_recv collection
  _buildInviteList() {
    return StreamBuilder(
      stream: userDoc.collection('invite_recv').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.data != null) {
          if (!querySnapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No invites found 😢',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: querySnapshot.data!.docs
                  .map<Widget>((document) => _buildInviteListItem(document))
                  .toList(),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // Build the user list item depending on the document
  _buildInviteListItem(DocumentSnapshot document) {
    return AcceptInviteTile(data: document);
  }
}
