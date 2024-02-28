import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/services/chat/elements/user_tile.dart';

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
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          CustomTextField(
            icon: Icons.search,
            hintText: 'Search a contact by username',
            isPassword: false,
            obscureText: false,
            controller: controller,
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  _buildUserList() {
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
                .map<Widget>((document) => _buildUserListItem(document))
                .toList(),
          );
        }
      },
    );
  }

  // TODO: Check if invite is already pending or sent
  // Implement pending invite page and manage invite function
  _buildUserListItem(DocumentSnapshot document) {
    final uid = _auth.currentUser!.uid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference inviteRef = userDoc.collection('invites');
    final DocumentReference sentDoc = inviteRef.doc('sent');
    final DocumentReference receivedDoc = inviteRef.doc('received');

    if (uid != document.id) {
      return const SizedBox();
    } else {
      return UserTile(
        data: document,
        userUid: document.id,
      );
    }
  }
}
