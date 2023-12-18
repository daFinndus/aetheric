import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ContactTile(
            imageUrl: 'https://picsum.photos/300/300',
            name: 'John Doe',
            lastMessage: 'Hello, World!',
            time: DateTime.now().toString(),
            readMessage: false,
          ),
          ContactTile(
            imageUrl: 'https://picsum.photos/300/300',
            name: 'Max Mustermann',
            lastMessage: 'Moin, Welt!',
            time: DateTime.now().toString(),
            readMessage: true,
          )
        ],
      ),
    );
  }
}
