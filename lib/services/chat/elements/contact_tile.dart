import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

class ContactTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final bool readMessage;

  const ContactTile(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.lastMessage,
      required this.time,
      required this.readMessage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: InkWell(
        onTap: () => _routeProfilePicture(context),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundImage: NetworkImage(imageUrl),
          child: const CircularProgressIndicator(),
        ),
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

  void _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          receiverName: name,
          receiverMail: 'john.doe@gmail.com',
          receiverId: 'ijawd92180ßgin2812',
          receiverImageUrl: imageUrl,
        ),
      ),
    );
  }

  void _routeProfilePicture(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Center(
          child: CircleAvatar(
            radius: 126.0,
            backgroundColor: Colors.transparent,
            foregroundImage: NetworkImage(imageUrl),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
