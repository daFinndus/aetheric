import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

// This should only be used for the invite page
// It's a tile that displays the user's username and profile picture
class AcceptInviteTile extends StatefulWidget {
  final DocumentSnapshot data;

  const AcceptInviteTile({
    super.key,
    required this.data,
  });

  @override
  State<AcceptInviteTile> createState() => _AcceptInviteTileState();
}

class _AcceptInviteTileState extends State<AcceptInviteTile> {
  late final String userUid = widget.data.id;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef = _firestore.collection('users');
  late final DocumentReference userDoc = userRef.doc(userUid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userDoc.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ListTile(title: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const ListTile(title: Text('Document does not exist'));
        } else {
          final username = snapshot.data!['personal_data']['username'];
          final imageUrl = snapshot.data!['technical_data']['imageUrl'];

          return ListTile(
            leading: CircleAvatar(
              radius: 24.0,
              child: imageUrl.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imageUrl,
                        width: 48.0,
                        height: 48.0,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
            trailing: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => {},
            ),
          );
        }
      },
    );
  }

  // Accept invite - add user to contact collection and remove from invite collection
  _acceptInvite() {}

  _addUserToContacts() {
    final uid = _auth.currentUser!.uid;
    final DocumentReference userDoc = userRef.doc(userUid);
    final CollectionReference contactsRefOwn = userDoc.collection('contacts');
    final CollectionReference contactsRefOther = userDoc.collection('contacts');

    contactsRefOwn.doc(userUid).set({});
  }
}
