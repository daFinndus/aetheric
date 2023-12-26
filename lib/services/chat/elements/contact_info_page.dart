import 'package:flutter/material.dart';

import 'package:aetheric/elements/custom_profile_text_box.dart';

class ContactInfoPage extends StatelessWidget {
  final String name;
  final String image;
  final String status;
  final String website;
  final String location;

  final int contacts;
  final int messagesSent;
  final DateTime joined;

  const ContactInfoPage({
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
        title: Text(
          'Contact Info',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 56.0),
              CircleAvatar(
                radius: 64.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              const SizedBox(height: 36.0),
              Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomProfileTextBox(
                      icon: Icons.person,
                      hintText: 'Name',
                      labelText: name,
                      readOnly: true,
                      obscureText: false,
                    ),
                    CustomProfileTextBox(
                      icon: Icons.info,
                      hintText: 'Status',
                      labelText: status,
                      readOnly: true,
                      obscureText: false,
                    ),
                    CustomProfileTextBox(
                      icon: Icons.location_on,
                      hintText: 'Location',
                      labelText: location,
                      readOnly: true,
                      obscureText: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomProfileTextBox(
                      icon: Icons.link,
                      hintText: 'Website',
                      labelText: website,
                      readOnly: true,
                      obscureText: false,
                    ),
                    CustomProfileTextBox(
                      icon: Icons.people,
                      hintText: 'Contacts',
                      labelText: contacts.toString(),
                      readOnly: true,
                      obscureText: false,
                    ),
                    CustomProfileTextBox(
                      icon: Icons.send,
                      hintText: 'Messages Sent',
                      labelText: messagesSent.toString(),
                      readOnly: true,
                      obscureText: false,
                    ),
                    CustomProfileTextBox(
                      icon: Icons.calendar_today,
                      hintText: 'Joined',
                      labelText: _cutDateToString(joined),
                      readOnly: true,
                      obscureText: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function for cutting our datetime object to a good looking string
  String _cutDateToString(DateTime date) {
    return '${date.day}.${date.month}.${date.year} - ${date.hour}:${date.minute}';
  }
}
