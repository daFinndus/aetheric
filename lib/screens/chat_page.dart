import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/elements/contact_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: const [
          ContactTile(
            username: 'JohnMaximus',
            firstName: 'John',
            lastName: 'Doe',
            email: 'john.doe@googlemail.com',
            id: '3',
            imageUrl: 'https://picsum.photos/200/300',
            timeMessage: '2021-08-01 12:00:00',
            lastMessage: 'Hello, World!',
            readMessage: true,
          ),
        ],
      ),
    );
  }
}
