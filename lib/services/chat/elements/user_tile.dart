import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

// This is only used for the add contact page
class UserTile extends StatefulWidget {
  final DocumentSnapshot data;
  final String userUid;

  const UserTile({
    super.key,
    required this.data,
    required this.userUid,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final username = widget.data['personal_data']['username'];
  late final imageUrl = widget.data['technical_data']['imageUrl'];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _manageInvite(),
      leading: CircleAvatar(
        radius: 24.0,
        child: imageUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                  width: 48.0,
                  height: 48.0,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              )
            : const Icon(Icons.person),
      ),
      title: Text(
        username,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  _manageInvite() {
    debugPrint('Sending invite...');
    _addInviteSender();
    _addInviteReceiver();
    const AlertDialog(
      title: Text('Invite sent!'),
    );
    debugPrint('Invite sent!');
  }

  _addInviteSender() async {
    String uid = _auth.currentUser!.uid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference inviteRef = userDoc.collection('invites');
    final DocumentReference sentDoc = inviteRef.doc('sent');

    // Add the user to the sent invites with an incremented count
    sentDoc.set({
      'uid': uid,
    }, SetOptions(merge: true));
  }

  _addInviteReceiver() {
    String uid = widget.userUid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference inviteRef = userDoc.collection('invites');
    final DocumentReference receivedDoc = inviteRef.doc('received');

    // Add the user to the received invites
    receivedDoc.set({
      uid,
    }, SetOptions(merge: true));
  }
}
