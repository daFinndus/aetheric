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
        title: InkWell(
          onTap: () => _routeContactInfo(context),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(receiverImageUrl),
              child: const CircularProgressIndicator(),
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
      ),
    );
  }

  // TODO: Implement a contact info page with certain user details, etc.
  void _routeContactInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Contact Info',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.titleTextStyle!.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
