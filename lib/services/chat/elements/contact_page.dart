import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_info_page.dart';

// This is the page where you can chat with a certain contact
class ContactPage extends StatelessWidget {
  final String name;
  final String image;
  final String status;
  final String website;
  final String location;

  final int contacts;
  final int messagesSent;
  final DateTime joined;

  const ContactPage({
    super.key,
    required this.name,
    required this.image,
    required this.status,
    required this.website,
    required this.location,
    required this.contacts,
    required this.messagesSent,
    required this.joined,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => _routeContactInfo(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundImage: NetworkImage(image),
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(width: 24.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _routeContactInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactInfoPage(
          name: name,
          status: status,
          image: image,
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
