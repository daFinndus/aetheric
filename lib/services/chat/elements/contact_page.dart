import 'dart:io';

import 'package:flutter/material.dart';

import 'package:aetheric/elements/custom_field_button.dart';

// FIXME: Messages appearing out of sight

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                foregroundImage: NetworkImage(widget.image),
                child: const CircleAvatar(
                  radius: 16.0,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.primary,
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => _closeKeyboard(context),
              child: ListView(
                children: [
                  // Insert messages here
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: const Center(
                      child: Text('Messages'),
                    ),
                  )
                ],
              ),
            ),
            _buildMessageInput(context)
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
        // Take account of the nodge thingy on iphones
        margin: Platform.isAndroid
            ? const EdgeInsets.only(bottom: 16.0)
            : const EdgeInsets.only(bottom: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80.0,
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: _messageController,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 6.0),
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _sendMessage(context),
              icon: const Icon(Icons.send),
            ),
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
      // Clear the messageController
      _messageController.clear();
    }
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
