import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aetheric/services/chat/backend/socket.dart';
import 'package:aetheric/services/chat/backend/message_model.dart';
import 'package:aetheric/services/chat/elements/message_sender.dart';
import 'package:aetheric/services/chat/elements/message_receiver.dart';
import 'package:aetheric/services/chat/elements/contact_info_page.dart';
import 'package:aetheric/elements/custom_field_button.dart';

// TODO: Fix page, messages appearing out of sight

// This is the page where you can chat with a certain contact
class ContactPage extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final String status;
  final String website;
  final String location;

  final int contacts;
  final int messagesSent;
  final DateTime joined;

  const ContactPage({
    super.key,
    required this.id,
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
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<MessageModel> _messageList = [];

  late final WebSocket socket = WebSocket(messageList: _messageList);

  @override
  void initState() {
    super.initState();
    socket.connectClient(widget.id);
  }

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
                foregroundImage: NetworkImage(widget.image),
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(width: 24.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMoreSettings(context),
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => _closeKeyboard(context),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: Platform.isIOS
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.8,
              margin: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _messageList.length,
                itemBuilder: (context, index) {
                  // If the message is from the source, it will be displayed on the right side
                  if (_messageList[index].type == 'source') {
                    return MessageSender(
                      message: _messageList[index].message,
                    );
                  } else {
                    return MessageReceiver(
                      message: _messageList[index].message,
                    );
                  }
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  // The message input is a text field to write messages and the send button
  _buildMessageInput(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80.0,
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: _messageController,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 6.0),
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () => _sendMessage(context),
                icon: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }

  // Function for closing the keyboard
  _closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  // Function for building MessageSender with the messageController.text everytime you click on the IconButton
  _sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        // Send the message to the server - message, source and target id
        socket.sendMessage(_messageController.text, '0', widget.id);
      });

      // Clear the messageController
      _messageController.clear();
    }
  }

  // Function for routing to the contact details page
  _routeContactInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactInfoPage(
          name: widget.name,
          status: widget.status,
          image: widget.image,
          website: widget.website,
          location: widget.location,
          contacts: widget.contacts,
          messagesSent: widget.messagesSent,
          joined: widget.joined,
        ),
      ),
    );
  }

  // Function for showing a modal bottom sheet with certain features
  _showMoreSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
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
              icon: Icons.image,
              text: 'Send a picture',
              function: () => {},
            ),
            CustomFieldButton(
              icon: Icons.file_copy_rounded,
              text: 'Send a file',
              function: () => {},
            ),
            CustomFieldButton(
              icon: Icons.location_searching_rounded,
              text: 'Send a location',
              function: () => {},
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
              thickness: 1.0,
              indent: 16.0,
              endIndent: 16.0,
            ),
            CustomFieldButton(
              icon: Icons.report,
              text: 'Report user',
              function: () => {},
            ),
            CustomFieldButton(
              icon: Icons.block,
              text: 'Block user',
              function: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
