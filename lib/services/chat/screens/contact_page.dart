import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/elements/custom_icon_button.dart';
import 'package:aetheric/services/chat/backend/message_model.dart';
import 'package:aetheric/services/chat/elements/message_sender.dart';
import 'package:aetheric/services/chat/backend/message_functions.dart';
import 'package:aetheric/services/chat/elements/message_receiver.dart';

// This is the page where you can chat with a certain contact
// TODO: Implement date for messages
// By divider that show stuff like 'yesterday', 'today' or a certain date
class ContactPage extends StatefulWidget {
  final DocumentSnapshot data;
  final String receiverUid;
  final String chatId;

  const ContactPage({
    super.key,
    required this.data,
    required this.receiverUid,
    required this.chatId,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Map<String, dynamic> data = widget.data.data()! as Map<String, dynamic>;

  final ScrollController _listviewController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference chatRef = _firestore.collection('chats');
  late final messageRef = chatRef.doc(widget.chatId).collection('messages');
  late final MessageFunctions _messageFunctions = MessageFunctions(
    chatId: widget.chatId,
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22.0,
                    child: data['technical_data']['imageUrl'].isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data['technical_data']['imageUrl'],
                              width: 44.0,
                              height: 44.0,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                              ),
                            ),
                          )
                        : const Icon(Icons.person),
                  ),
                  const SizedBox(width: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['personal_data']['username'],
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
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
          body: StreamBuilder(
            stream: messageRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return SizedBox(
                    width: SizerUtil.width,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Column(
                        children: [
                          const SizedBox(height: 8.0),
                          Expanded(child: _buildMessageList(context)),
                          const SizedBox(height: 16.0),
                          _buildMessageInput(context),
                        ],
                      ),
                    ),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  // Function for uploading our message to the database
  _sendMessage() {
    String message = _messageController.text.trim();

    if (_messageController.text.isNotEmpty) {
      // Create our message model
      MessageModel messageModel = MessageModel(
        uid: _firebaseAuth.currentUser!.uid,
        message: message,
        datetime: DateTime.timestamp().toString(),
      );

      // Add the message model to our database
      _messageFunctions.sendMessage(messageModel);
      // Clear the messageController
      _messageController.clear();
      // Make sure the listview is scrolled down to the bottom
      _scrollUp();
    }
  }

  // Function for deleting the chat from the database
  _deleteChat() {
    debugPrint('Deleting chat...');
    debugPrint('Chat ID: ${widget.chatId}');

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .get()
        .then((querySnapshot) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    FirebaseFirestore.instance.collection('users').doc(widget.chatId).delete();
    Navigator.pop(context);
  }

  // Function for scrolling the listview to the top
  _scrollUp() {
    _listviewController.animateTo(
      _listviewController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // The message list is a list of all messages in the chat
  _buildMessageList(BuildContext context) {
    return StreamBuilder(
      stream: _messageFunctions.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: SizerUtil.width,
            height: SizerUtil.height,
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
            controller: _listviewController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final data = messages[index].data() as Map<String, dynamic>;

              String messageText = data['message'];
              String messageTime = data['datetime'];
              String messageUid = data['uid'];

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
              width: SizerUtil.width - 80.0,
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: _messageController,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
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
              onPressed: () => _sendMessage(),
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
        width: SizerUtil.width,
        height: SizerUtil.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomIconButton(
              icon: Icons.image,
              text: 'Send a picture',
              function: () => {},
            ),
            CustomIconButton(
              icon: Icons.file_copy_rounded,
              text: 'Send a file',
              function: () => {},
            ),
            CustomIconButton(
              icon: Icons.location_searching_rounded,
              text: 'Send a location',
              function: () => {},
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSecondary,
              thickness: 1.0,
              indent: 16.0,
              endIndent: 16.0,
            ),
            CustomIconButton(
              icon: Icons.delete,
              text: 'Delete chat',
              function: () => _deleteChat(),
            ),
            CustomIconButton(
              icon: Icons.report,
              text: 'Report user',
              function: () => {},
            ),
            CustomIconButton(
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
