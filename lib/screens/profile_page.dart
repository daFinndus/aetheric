import 'package:aetheric/elements/custom_field_button.dart';
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
  String imageUrl = '';
  String bannerUrl = '';

  @override
  void initState() {
    // TODO: Retreive data from database to use the username
    super.initState();

    name = 'Finn Luca Jensen';
    status = 'Hey, I am using Aetheric!';
    imageUrl = 'https://picsum.photos/200';
    bannerUrl = 'https://picsum.photos/300';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Go ahead and edit, ${name.split(' ')[0]}.',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Edit your profile, view it and more',
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreSettings(context),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 16.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 128.0,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  bannerUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 96.0,
            child: CircleAvatar(
              radius: 64.0,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
        ],
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
              function: () => {},
            ),
            CustomFieldButton(
              icon: Icons.remove_red_eye,
              text: 'View your profile',
              function: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
