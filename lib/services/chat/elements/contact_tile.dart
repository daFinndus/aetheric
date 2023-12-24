import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatelessWidget {
  final String name;
  final String image;
  final String status;
  final String website;
  final String location;

  final int contacts;
  final int messagesSent;
  final DateTime joined;

  final bool readMessage;
  final String lastMessage;
  final DateTime timeMessage;

  const ContactTile({
    super.key,
    required this.name,
    required this.image,
    required this.status,
    required this.website,
    required this.location,
    required this.contacts,
    required this.messagesSent,
    required this.joined,
    required this.readMessage,
    required this.lastMessage,
    required this.timeMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: NetworkImage(image),
        child: const CircularProgressIndicator(),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${timeMessage.hour < 10 ? '0' : ''}${timeMessage.hour}:${timeMessage.minute < 10 ? '0' : ''}${timeMessage.minute}',
              style: const TextStyle(fontSize: 12.0),
            ),
            // Text
            readMessage
                ? const Icon(Icons.mark_email_read)
                : const Icon(Icons.mark_email_unread),
          ],
        ),
      ),
    );
  }

  void _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          name: name,
          image: image,
          status: status,
          website: website,
          location: location,
          contacts: contacts,
          messagesSent: messagesSent,
          joined: joined,
        ),
      ),
    );
  }
}
