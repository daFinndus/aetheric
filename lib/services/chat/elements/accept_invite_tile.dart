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
  // This is the uid of the other user we're working with
  late final String uid = _auth.currentUser!.uid;
  late final String userUid = widget.data.id;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userColl = _firestore.collection('users');
  late final DocumentReference userDoc = userColl.doc(userUid);

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
            // Open contact page here
            onTap: () => {},
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
            trailing: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    // Add the user to our contacts here
                    onPressed: () => _acceptInvite(),
                    icon: const Icon(Icons.check),
                  ),
                  IconButton(
                    // Delete the invite here
                    onPressed: () => _denyInvite(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Function for deleting the invite and adding the contact
  _acceptInvite() {
    userColl.doc(uid).collection('invite_recv').doc(userUid).delete();
    userColl.doc(userUid).collection('invite_sent').doc(uid).delete();

    userColl.doc(uid).collection('contacts').doc(userUid).set({
      'exists': true,
    });

    userColl.doc(userUid).collection('contacts').doc(uid).set({
      'exists': true,
    });
  }

  // Function for denying the invite, basically just deleting it
  _denyInvite() {
    userColl.doc(uid).collection('invite_recv').doc(userUid).delete();
    userColl.doc(userUid).collection('invite_sent').doc(uid).delete();
  }
}
