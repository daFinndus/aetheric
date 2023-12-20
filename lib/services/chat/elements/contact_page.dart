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
        toolbarHeight: 64.0,
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: InkWell(
            onTap: () => _routeProfilePicture(context),
            child: CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(receiverImageUrl),
              child: const CircularProgressIndicator(),
            ),
          ),
          title: Text(
            receiverName,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            ),
          ),
        ),
      ),
    );
  }

  void _routeProfilePicture(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile Picture',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: CircleAvatar(
              radius: 124.0,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(receiverImageUrl),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
