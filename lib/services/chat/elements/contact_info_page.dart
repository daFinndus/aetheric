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
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 686.0,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 48.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 106.0,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.9,
                top: 76.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contacts',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            contacts.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'User since',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            calculateJoinTime(joined),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16.0,
                child: CircleAvatar(
                  radius: 64.0,
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(image),
                  ),
                ),
              ),
              Positioned(
                top: 186.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                        icon: Icons.link,
                        hintText: 'Website',
                        labelText: website,
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
              ),
              Positioned(
                top: 452.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      CustomProfileTextBox(
                        icon: Icons.send,
                        hintText: 'Messages sent',
                        labelText: messagesSent.toString(),
                        readOnly: true,
                        obscureText: false,
                      ),
                      CustomProfileTextBox(
                        icon: Icons.person,
                        hintText: 'Contacts',
                        labelText: contacts.toString(),
                        readOnly: true,
                        obscureText: false,
                      ),
                      CustomProfileTextBox(
                        icon: Icons.calendar_month_rounded,
                        hintText: 'User since',
                        labelText:
                            '${joined.day < 10 ? '0' : ''}${joined.day}.${joined.month < 10 ? '0' : ''}${joined.month}.${joined.year}',
                        readOnly: true,
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function for calculating the time the user joined
  // And returning it as a string like '1 day' or '3 months'
  String calculateJoinTime(DateTime time) {
    Duration difference = DateTime.now().difference(time);

    if (difference.inDays <= 7) {
      return (difference.inDays == 1) ? '1 day' : '${difference.inDays} days';
    } else if (difference.inDays <= 30) {
      return (difference.inDays ~/ 7 == 1)
          ? '1 week'
          : '${difference.inDays ~/ 7} weeks';
    } else if (difference.inDays <= 365) {
      return (difference.inDays ~/ 30 == 1)
          ? '1 month'
          : '${difference.inDays ~/ 30} months';
    } else {
      return (difference.inDays ~/ 365 == 1)
          ? '1 year'
          : '${difference.inDays ~/ 365} years';
    }
  }

  String calculateMessageAmount(int messagesSent) {
    if (messagesSent >= 1000) {
      return '${messagesSent ~/ 1000}K';
    }
    return messagesSent.toString();
  }
}
