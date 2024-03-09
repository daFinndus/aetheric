import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/popups/invite_page.dart';
import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/popups/add_user_page.dart';
import 'package:aetheric/services/chat/elements/contact_tile.dart';
import 'package:aetheric/services/chat/elements/feedback_tile.dart';

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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            leading: FutureBuilder(
              future: _checkPendingInvites(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return IconButton(
                    tooltip: 'Manage your invites',
                    icon: const Icon(Icons.mail),
                    onPressed: () => _app.showBottomSheet(
                      context,
                      const InvitePage(),
                    ),
                  );
                } else {
                  return IconButton(
                    tooltip: 'Manage your invites',
                    icon: const Icon(Icons.mail),
                    onPressed: () => _app.showErrorFlushbar(
                      context,
                      'No pending invites',
                    ),
                  );
                }
              },
            ),
            actions: [
              FutureBuilder(
                future: _checkAvailableUsers(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return IconButton(
                      tooltip: 'Add a new contact',
                      icon: const Icon(Icons.person_add),
                      onPressed: () => _app.showBottomSheet(
                        context,
                        const AddUserPage(),
                      ),
                    );
                  }
                  return IconButton(
                    tooltip: 'Add a new contact',
                    icon: const Icon(Icons.person_add),
                    onPressed: () => _app.showErrorFlushbar(
                      context,
                      'No users available to add',
                    ),
                  );
                },
              ),
            ],
          ),
          body: SizedBox(
            width: SizerUtil.width,
            height: SizerUtil.height,
            child: Column(
              children: [
                const FeedbackTile(),
                Expanded(
                  child: _buildContactList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // This function generates a chat id based on the two user ids
  _generateChatId(String currentId, String otherId) {
    final List<String> uids = [currentId, otherId];
    uids.sort();
    return uids.join('');
  }

  // This function checks if there are any pending invites
  Future<bool> _checkPendingInvites() async {
    bool data = false;

    final invRecvRef = userRef.collection('invites_recv');
    final invRecvSnapshot = await invRecvRef.get();

    if (invRecvSnapshot.docs.isNotEmpty) {
      data = true;
    }

    return data;
  }

  // This function returns true if someone of every user available is not in our contacts
  // Or the user isn't the current user or in our invite collections
  // This function could be optimized
  Future<bool> _checkAvailableUsers() async {
    bool data = false;

    final invSentRef = userRef.collection('invites_sent').get();
    final invRecvRef = userRef.collection('invites_recv').get();
    final contactRef = userRef.collection('contacts').get();

    final userSnapshot = await _firestore.collection('users').get();
    final invSentSnapshot = await invSentRef;
    final invRecvSnapshot = await invRecvRef;
    final contactSnapshot = await contactRef;

    final Set<String> unavailableUsers = {};

    for (var document in invSentSnapshot.docs) {
      unavailableUsers.add(document.id);
    }

    for (var document in invRecvSnapshot.docs) {
      unavailableUsers.add(document.id);
    }

    for (var document in contactSnapshot.docs) {
      unavailableUsers.add(document.id);
    }

    // Check if we already have the user in our contacts or invites
    // Or if we are the user that is being checked out
    for (var document in userSnapshot.docs) {
      for (var user in unavailableUsers) {
        if (document.id == user || document.id == uid) {
          data = false;
        } else {
          data = true;
        }
      }
    }
    return data;
  }

  // Build the entire contact list
  _buildContactList() {
    return StreamBuilder(
      stream: userRef.collection('contacts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.data != null) {
          if (!querySnapshot.hasData || querySnapshot.data!.docs.isEmpty) {
            return _buildNoContactsWidget();
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: querySnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final uid = querySnapshot.data!.docs[index].id;

                return FutureBuilder(
                  future: _firestore.collection('users').doc(uid).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.data != null) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: Icon(Icons.error));
                      } else {
                        debugPrint('Trying to build contact list item..');
                        return _buildContactListItem(userSnapshot.data!);
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Build each contact list item
  _buildContactListItem(DocumentSnapshot document) {
    final receiverUid = document.id;
    final chatId = _generateChatId(uid, receiverUid);

    return ContactTile(
      data: document,
      receiverUid: receiverUid,
      chatId: chatId,
    );
  }

  // Function for displaying widgets when there are no contacts
  _buildNoContactsWidget() {
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
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
