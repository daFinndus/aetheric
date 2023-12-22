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
            name: 'John Doe',
            status: 'This is an application by daFinndus',
            imageUrl: 'https://picsum.photos/200',
            lastMessage: 'Hello, world!',
            timeMessage: '2021-10-10 10:10:10',
            readMessage: true,
          ),
        ],
      ),
    );
  }
}
