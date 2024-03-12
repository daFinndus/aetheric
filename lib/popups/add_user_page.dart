import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/services/chat/elements/add_user_tile.dart';

// This page is for the user to send invites to other users
class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final AppFeatures _app = AppFeatures();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef = _firestore.collection('users');

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          width: SizerUtil.width,
          height: SizerUtil.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              Expanded(
                child: _buildUserList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // FIXME: No loading indicator while fetching data
  // Build user list from the database with user tiles
  _buildUserList() {
    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.data != null) {
          if (!querySnapshot.hasData) {
            return const Center(child: Text('No data available...'));
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: querySnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: _checkInvitations(querySnapshot.data!.docs[index].id),
                  builder: (context, AsyncSnapshot<bool> boolSnapshot) {
                    if (boolSnapshot.data != null) {
                      if (boolSnapshot.data!) {
                        return const SizedBox();
                      } else {
                        return _buildUserListItem(
                          querySnapshot.data!.docs[index],
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // Build user tiles for each user in the database
  // Also check if the user already has a pending invite
  Widget _buildUserListItem(DocumentSnapshot document) {
    debugPrint('Now trying to build user list item for ${document.id}');
    debugPrint('This is our uid ${_auth.currentUser?.uid}');

    final uid = _auth.currentUser!.uid;

    // If nothing of the above is true, return the user tile
    return AddUserTile(
      document: document,
      function: () => _manageInvites(uid, document.id, document),
      userUid: document.id,
      icon: Icons.person_add,
    );
  }

  // This function checks if the user already has a pending or sent invitation
  // It also checks if the user is already in our contacts
  // This was carried by ChatGPT - thank you very much!
  Future<bool> _checkInvitations(String userId) async {
    final uid = _auth.currentUser!.uid;
    final invSentRef = userRef.doc(uid).collection('invite_sent');
    final invRecvRef = userRef.doc(uid).collection('invite_recv');
    final contactRef = userRef.doc(uid).collection('contacts');

    // Check if we sent an invite to the user or received one
    final sentDoc = await invSentRef.doc(userId).get();
    final recvDoc = await invRecvRef.doc(userId).get();
    final contactDoc = await contactRef.doc(userId).get();

    if (userId == uid) return true;
    return sentDoc.exists || recvDoc.exists || contactDoc.exists;
  }

  // Executes all necessary functions
  _manageInvites(String ownUid, String otherUid, DocumentSnapshot document) {
    try {
      debugPrint('Sending invite...');
      _sendInvite(ownUid, otherUid);
      _receiveInvite(otherUid);
      debugPrint('Invite sent!');
      _app.showSuccessFlushbar(context, 'Invite sent!');
    } catch (e) {
      debugPrint('Error sending invite: $e');
      _app.showErrorFlushbar(context, 'Error sending invite');
    }
    setState(() {
      debugPrint('Reloading...');
    });
  }

  // Send a invite to a certain user
  // Basically add our uid to our invite_send collection
  _sendInvite(String uid, String otherUid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference invSentRef = userDoc.collection('invite_sent');

    await invSentRef.doc(otherUid).set({
      'exists': true,
    });
  }

  // Receive an invite from a certain user
  // Basically add the user's uid to our invite_recv collection
  _receiveInvite(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc = firestore.collection('users').doc(uid);
    final CollectionReference invSentRef = userDoc.collection('invite_recv');

    await invSentRef.doc(_auth.currentUser?.uid).set({
      'exists': true,
    });
  }
}
