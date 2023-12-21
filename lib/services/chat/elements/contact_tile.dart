import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

class ContactTile extends StatelessWidget {
  final String username; // This is the username
  final String firstName; // This is the first name
  final String lastName; // This is the last name
  final String email; // This is the email
  final String id; // This is the user id
  final String imageUrl; // This is the image url of the profile picture
  final String timeMessage; // This is the time of the last message
  final String lastMessage; // This is the last message
  final bool readMessage; // This is the read message status

  const ContactTile({
    super.key,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.id,
    required this.imageUrl,
    required this.timeMessage,
    required this.lastMessage,
    required this.readMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: NetworkImage(imageUrl),
        child: const CircularProgressIndicator(),
      ),
      title: Text(username),
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

  void _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          username: username,
          firstName: firstName,
          lastName: lastName,
          email: email,
          id: id,
          imageUrl: imageUrl,
          timeMessage: timeMessage,
          lastMessage: lastMessage,
          readMessage: readMessage,
        ),
      ),
    );
  }
}
