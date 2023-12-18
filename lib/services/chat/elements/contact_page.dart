import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  final String receiverName;
  final String receiverMail;
  final String receiverId;
  final String receiverImageUrl;

  const ContactPage(
      {super.key,
      required this.receiverName,
      required this.receiverMail,
      required this.receiverId,
      required this.receiverImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.transparent,
            foregroundImage: NetworkImage(receiverImageUrl),
            child: const CircularProgressIndicator(),
          ),
          title: Text(
            receiverName,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
