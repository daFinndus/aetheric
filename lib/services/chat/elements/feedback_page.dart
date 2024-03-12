import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/app/features.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  final AppFeatures _app = AppFeatures();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _fbackColl = _firestore.collection('feedback');

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 22.0,
                  child: Icon(Icons.feedback),
                ),
                const SizedBox(width: 20.0),
                Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          body: SizedBox(
            width: SizerUtil.width,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  _buildFeedbackInput(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function for sending a feedback
  _sendFeedback() {
    String feedback = _feedbackController.text.trim();

    if (_feedbackController.text.isNotEmpty) {
      _fbackColl.add({
        'uid': _auth.currentUser!.uid,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _app.showSuccessFlushbar(context, 'Feedback sent!');

      _feedbackController.clear();
    }
  }

  // The feedback input is a text field to send feedback to the developers
  _buildFeedbackInput(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizerUtil.width - 80.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: _feedbackController,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 25,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _sendFeedback(),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
