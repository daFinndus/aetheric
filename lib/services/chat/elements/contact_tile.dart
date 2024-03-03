import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatefulWidget {
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
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool sender = false;
  bool marquee = false;

  final preferences = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('datetime', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, querySnapshot) {
        if (querySnapshot.connectionState == ConnectionState.waiting) {
          return _buildTile(context, 'Loading...', '', '', false);
        } else if (querySnapshot.hasError) {
          return _buildTile(context, 'Error', '', '', false);
        } else {
          final messages = querySnapshot.data!.docs;

          if (querySnapshot.data != null) {
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
          return _buildTile(context, 'Error', '', '', false);
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
    Map<String, dynamic> data = widget.data.data() as Map<String, dynamic>;

    final username = data['personal_data']['username'];
    final imageUrl = data['technical_data']['imageUrl'];

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
      subtitle: SizedBox(
        height: 18.0,
        child: marquee
            ? Marquee(
                text: foundMessage
                    ? _checkStringLength(message, uid)
                    : 'No messages yet',
                style: TextStyle(
                  fontSize: 14.0,
                  color: sender
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startAfter: const Duration(seconds: 1),
              )
            : Text(
                foundMessage
                    ? _checkStringLength(message, uid)
                    : 'No messages yet',
                style: TextStyle(
                  fontSize: 14.0,
                  color: sender
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
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

  // Get the user's preferences
  _getPreferences() async {
    marquee = await preferences.then((prefs) {
      return prefs.getBool('marquee') ?? false;
    });
  }

  // Shorten the string so the tile doesn't overflow
  _checkStringLength(String message, String messageUid) {
    final senderUid = FirebaseAuth.instance.currentUser!.uid;

    if (messageUid == senderUid) sender = true;

    message = message.replaceFirst('\n', ' ');
    message = message.replaceAll('\n', '');

    if (!marquee && message.length > 30) {
      message = '${message.substring(0, 30)}...';
    }

    return message;
  }

  _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          data: widget.data,
          receiverUid: widget.receiverUid,
          chatId: widget.chatId,
        ),
      ),
    );
  }
}
