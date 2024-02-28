import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatelessWidget {
  final DocumentSnapshot data;
  final String receiverUid;
  final String chatId;

  const ContactTile({
    super.key,
    required this.data,
    required this.receiverUid,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('datetime', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildTile(context, 'Loading...', '', '', false);
        } else if (snapshot.hasError) {
          return _buildTile(context, 'Error', '', '', false);
        } else {
          final messages = snapshot.data!.docs;

          if (messages.isNotEmpty) {
            final messageData = messages.first.data() as Map<String, dynamic>;
            final messageUid = messageData['uid']!;
            final messageText = messageData['message']!;
            final messageTime = DateTime.parse(messageData['datetime']!);

            // This does work, but it's hella useless as the notification is already shown
            // And the user cannot receive any notifications without being in the chat page
            return _buildTile(
              context,
              messageText,
              '${messageTime.hour < 10 ? '0' : ''}${messageTime.hour}:${messageTime.minute < 10 ? '0' : ''}${messageTime.minute}',
              messageUid,
              true,
            );
          } else {
            return _buildTile(context, 'No messages yet', '', '', false);
          }
        }
      },
    );
  }

  // Builds the tile for the contact
  Widget _buildTile(
    BuildContext context,
    String message,
    String time,
    String uid,
    bool foundMessage,
  ) {
    final username = data['personal_data']['username'];
    final imageUrl = data['personal_data']['imageUrl'];

    return ListTile(
      onTap: () => _routeContactPage(context),
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        foundMessage
            ? _checkStringLength(message, uid, username)
            : 'Loading...',
        style: const TextStyle(fontSize: 12.0),
      ),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              foundMessage ? time : '',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  // Shorten the string so the tile doesn't overflow
  _checkStringLength(String message, String messageUid, String username) {
    final senderUid = FirebaseAuth.instance.currentUser!.uid;

    if (messageUid == senderUid) {
      message = 'You: $message';
    } else {
      message = '$username: $message';
    }

    message = message.replaceFirst('\n', ' ');
    message = message.replaceAll('\n', '');
    if (message.length >= 30) message = '${message.substring(0, 30)}...';

    return message;
  }

  void _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          data: data,
          receiverUid: receiverUid,
          chatId: chatId,
        ),
      ),
    );
  }
}
