import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_tile.dart';
import 'package:aetheric/elements/custom_field_button.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat with your friends.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search for contacts, add someone and more',
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreSettings(context),
          ),
        ],
      ),
      body: ListView(
        children: const [
          ContactTile(
            name: 'John Doe',
            status: 'This is an application by daFinndus',
            imageUrl: 'https://picsum.photos/100',
            lastMessage: 'Hello, world!',
            timeMessage: '2021-10-10 04:20:59',
            readMessage: true,
          ),
          ContactTile(
            name: 'Max Mustermann',
            status: 'Das ist eine Anwendung von daFinndus',
            imageUrl: 'https://picsum.photos/100',
            lastMessage: 'Moin, Welt!',
            timeMessage: '2021-10-10 13:37:43',
            readMessage: false,
          ),
        ],
      ),
    );
  }

  // Function for showing a modal bottom sheet with certain features
  // Features here are adding a contact and searching through contacts
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
              icon: Icons.search_rounded,
              text: 'Search through your contacts',
              function: () => {},
            ),
            CustomFieldButton(
              icon: Icons.add,
              text: 'Add a contact',
              function: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
