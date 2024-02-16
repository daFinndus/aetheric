import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatefulWidget {
  final String receiverId;
  final String chatId;

  const ContactTile({
    super.key,
    required this.receiverId,
    required this.chatId,
  });

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  String receiverName = '';
  String receiverImageUrl = '';

  String lastMessage = '';
  DateTime timeMessage = DateTime(1970, 1, 1);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userColl = _firestore.collection('users');
  late final DocumentReference _docRef = _userColl.doc(widget.receiverId);

  late final CollectionReference _chatColl = _firestore.collection('chats');
  late final DocumentReference _chatDocRef = _chatColl.doc(widget.chatId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Retrieve user data
    Future.delayed(Duration.zero, () {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: CircleAvatar(
        radius: 24.0,
        child: receiverImageUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: receiverImageUrl,
                  width: 48.0,
                  height: 48.0,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              )
            : const Icon(Icons.person),
      ),
      title: Text(
        receiverName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(lastMessage == '' ? 'No messages yet' : lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${timeMessage.hour < 10 ? '0' : ''}${timeMessage.hour}:${timeMessage.minute < 10 ? '0' : ''}${timeMessage.minute}',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  // Function for retrieving the data of the receiver
  _getData() {
    String firstName;
    String lastName;

    _userColl
        .doc(widget.receiverId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot.get('personal_data')['firstName'];
          lastName = documentSnapshot.get('personal_data')['lastName'];
          receiverImageUrl = documentSnapshot.get('personal_data')['imageUrl'];

          // Set the name of the receiver
          receiverName = '$firstName $lastName';
        });
      }
    });
  }

  void _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          receiverId: widget.receiverId,
          chatId: widget.chatId,
        ),
      ),
    );
  }
}
