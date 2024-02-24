import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
// TODO: Implement last message feature
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
  late Map<String, dynamic> data = widget.data.data()! as Map<String, dynamic>;

  String lastMessage = '';
  DateTime timeMessage = DateTime(1970, 1, 1);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: CircleAvatar(
        radius: 24.0,
        child: data['personal_data']['imageUrl'].isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: data['personal_data']['imageUrl'],
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
        data['personal_data']['username'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(lastMessage == '' ? 'No messages yet' : lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastMessage == ''
                  ? ''
                  : '${timeMessage.hour < 10 ? '0' : ''}${timeMessage.hour}:${timeMessage.minute < 10 ? '0' : ''}${timeMessage.minute}',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  // This function seems to work 50/50
  // It does redirect but when hitting the go backwards arrow, it directs to the wrong page
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
