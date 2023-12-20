import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

class ContactTile extends StatelessWidget {
  final String name;
  final String email;
  final String id;
  final String imageUrl;
  final String lastMessage;
  final String time;
  final bool readMessage;

  const ContactTile(
      {super.key,
      required this.name,
      required this.email,
      required this.id,
      required this.imageUrl,
      required this.lastMessage,
      required this.time,
      required this.readMessage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(
        context,
        name,
        email,
        id,
        imageUrl,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: NetworkImage(imageUrl),
        child: const CircularProgressIndicator(),
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time.substring(11, 16)),
            // Text
            readMessage
                ? const Icon(Icons.mark_email_read)
                : const Icon(Icons.mark_email_unread),
          ],
        ),
      ),
    );
  }

  void _routeContactPage(
    BuildContext context,
    String receiverName,
    String receiverMail,
    String receiverId,
    String receiverImageUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          receiverName: receiverName,
          receiverMail: receiverMail,
          receiverId: receiverId,
          receiverImageUrl: receiverImageUrl,
        ),
      ),
    );
  }
}
