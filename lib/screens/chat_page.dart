import 'package:flutter/material.dart';

import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/services/chat/elements/contact_tile.dart';

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
        children: [
          ContactTile(
            id: '1',
            name: 'John Doe',
            image: 'https://picsum.photos/100',
            status: 'Yo, I am Doe!',
            website: 'https://john-doe.com',
            location: 'USA, New York',
            contacts: 17,
            messagesSent: 1249,
            joined: DateTime(2021, 5, 17, 12, 39, 24),
            readMessage: false,
            lastMessage: 'Hello, how are you?',
            timeMessage: DateTime(2023, 5, 17, 12, 39, 24),
          ),
          ContactTile(
            id: '2',
            name: 'Max Mustermann',
            image: 'https://picsum.photos/100',
            status: 'Max ist im Haus.',
            website: 'www.max-mustermann.de',
            location: 'Germany, Berlin',
            contacts: 12,
            messagesSent: 985021,
            joined: DateTime(2022, 7, 23, 12, 56, 37),
            readMessage: false,
            lastMessage: 'Hey, wie geht es dir?',
            timeMessage: DateTime.now(),
          )
        ],
      ),
    );
  }

  // Function for showing a modal bottom sheet with certain features
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
