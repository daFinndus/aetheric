import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/elements/custom_field_button.dart';
import 'package:aetheric/services/chat/backend/message_model.dart';
import 'package:aetheric/services/chat/elements/message_sender.dart';
import 'package:aetheric/services/chat/backend/message_functions.dart';
import 'package:aetheric/services/chat/elements/message_receiver.dart';

// This is the page where you can chat with a certain contact
class ContactPage extends StatefulWidget {
  final String receiverUid;
  final String chatId;

  const ContactPage({
    super.key,
    required this.receiverUid,
    required this.chatId,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _messageController = TextEditingController();

  String receiverUsername = '';
  String receiverImageUrl = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userColl = _firestore.collection('users');
  late final MessageFunctions _messageFunctions = MessageFunctions(
    chatId: widget.chatId,
  );

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getData();
    });
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
                child: receiverImageUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: receiverImageUrl,
                          width: 40.0,
                          height: 40.0,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
              ),
              const SizedBox(width: 24.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverUsername,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Messaging from  💻',
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
                  const SizedBox(height: 16.0),
                  _buildMessageList(context),
                ],
              ),
            ),
            _buildMessageInput(context)
          ],
        ),
      ),
    );
  }

  // Function for retrieving the data of the receiver
  _getData() {
    _userColl
        .doc(widget.receiverUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          receiverUsername = documentSnapshot.get('personal_data')['username'];
          receiverImageUrl = documentSnapshot.get('personal_data')['imageUrl'];
        });
      }
    });
  }

  // TODO: Erase whitespace at end of message
  // Function for uploading our message to the database
  _sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty) {
      // Create our message model
      MessageModel messageModel = MessageModel(
        uid: _firebaseAuth.currentUser!.uid,
        message: _messageController.text,
        datetime: DateTime.timestamp().toString(),
      );

      // Add the message model to our database
      _messageFunctions.sendMessage(messageModel);
      // Clear the messageController
      _messageController.clear();
    }
  }

  // Function for closing the keyboard
  _closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  // The message list is a list of all messages in the chat
  _buildMessageList(BuildContext context) {
    return StreamBuilder(
      stream: _messageFunctions.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          // Create a list of all messages in the collection
          final messages = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageData =
                  messages[index].data() as Map<String, dynamic>;

              String messageText = messageData['message'];
              String messageTime = messageData['datetime'];
              String messageUid = messageData['uid'];

              // Check if the message is sent by the user or the receiver
              if (messageUid == _firebaseAuth.currentUser!.uid) {
                return MessageSender(
                  message: messageText,
                  datetime: messageTime,
                );
              } else {
                return MessageReceiver(
                  message: messageText,
                  datetime: messageTime,
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  // The message input is a text field to write messages and the send button
  // TODO: Make sure input doesn't overlap the messages
  // Instead the input should displace the messages upwards
  _buildMessageInput(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // Take account of the nodge thingy on iphones
        padding: Platform.isAndroid
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
