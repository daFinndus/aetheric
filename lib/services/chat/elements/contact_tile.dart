import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatelessWidget {
  final String name;
  final String status;
  final String imageUrl;
  final String lastMessage;
  final String timeMessage;
  final bool readMessage;

  const ContactTile({
    super.key,
    required this.name,
    required this.status,
    required this.imageUrl,
    required this.lastMessage,
    required this.timeMessage,
    required this.readMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(
        context,
        name,
        imageUrl,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: NetworkImage(imageUrl),
        child: const CircularProgressIndicator(),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(timeMessage.substring(11, 16)),
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
    String name,
    String imageUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          name: name,
          status: status,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
