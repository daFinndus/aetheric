import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/elements/custom_profile_text_box.dart';
import 'package:aetheric/popups/edit_profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Fetch data in init state
  String name = '';
  String status = '';
  String location = '';
  String image = '';
  String website = '';

  int contacts = 0;
  int messagesSent = 0;
  DateTime joined = DateTime(0, 0, 0, 0, 0, 0);

  @override
  void initState() {
    // TODO: Retreive data from database and fetch data
    super.initState();

    name = 'Finn Luca Jensen';
    status = 'Hey, I am using Aetheric!';
    location = 'Germany, Kiel';
    image = 'https://picsum.photos/200';
    website = 'https://github.com/daFinndus';

    contacts = 2;
    messagesSent = 42069;
    joined = DateTime(2002, 11, 10, 09, 43, 00);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "That's you, ${name.split(' ')[0]}!",
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit your profile',
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        dragStartBehavior: DragStartBehavior.start,
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
                    color: Theme.of(context).colorScheme.primary,
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

  // Function for showing a modal bottom sheet with certain features
  // Features here are editing the profile and viewing it
  _showMoreSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomFieldButton(
              icon: Icons.edit,
              text: 'Edit your profile',
              function: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    name: name,
                    status: status,
                    website: website,
                    location: location,
                  ),
                ),
              ),
            ),
          ],
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
