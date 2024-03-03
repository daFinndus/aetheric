import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_text_button.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  final TextEditingController _messageController = TextEditingController();
  late final uid = _auth.currentUser!.uid;

  final AppFeatures _app = AppFeatures();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference feedbackColl = _firestore.collection('feedback');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.575,
      padding: const EdgeInsets.only(top: 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Send a message to the developer 🗒️',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildMessageInput(context),
          ),
        ],
      ),
    );
  }

  // The message input is a text field to write messages and the send button
  _buildMessageInput(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80.0,
              height: 256.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              child: TextFormField(
                controller: _messageController,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 12,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 6.0),
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 56.0),
              child: CustomTextButton(
                text: 'Send',
                function: () => _sendMessage(),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Send the message to the feedback collection
  _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      feedbackColl.add({
        'uid': uid,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _app.showSuccessFlushbar(
        context,
        'Message sent',
      );
    } else {
      _app.showErrorFlushbar(
        context,
        'Message cannot be empty',
      );
    }
  }
}
