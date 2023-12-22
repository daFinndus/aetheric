import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_info_page.dart';

// This is the page where you can chat with a certain contact
class ContactPage extends StatelessWidget {
  final String name;
  final String status;
  final String imageUrl;

  const ContactPage({
    super.key,
    required this.name,
    required this.status,
    required this.imageUrl,
  });

  // TODO: Fix the appbar, backwards arrow too far apart from picture

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
                foregroundImage: NetworkImage(imageUrl),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.secondary,
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

  // TODO: Implement a contact info page with certain user details, etc.

  void _routeContactInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactInfoPage(
          name: name,
          status: status,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
