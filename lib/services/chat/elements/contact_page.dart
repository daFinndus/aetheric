import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  final String username; // This is the username
  final String firstName; // This is the first name
  final String lastName; // This is the last name
  final String email; // This is the email
  final String id; // This is the user id
  final String imageUrl; // This is the image url of the profile picture
  final String timeMessage; // This is the time of the last message
  final String lastMessage; // This is the last message
  final bool readMessage; // This is the read message status

  const ContactPage({
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
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => _routeContactInfo(context),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(
                imageUrl,
              ),
              child: const CircularProgressIndicator(),
            ),
            title: Text(
              username,
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 64.0,
                backgroundColor: Colors.transparent,
                foregroundImage: NetworkImage(
                  imageUrl,
                ),
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 16.0),
              Text(
                username,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$firstName $lastName',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                id,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
