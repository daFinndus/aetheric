import 'package:flutter/material.dart';

import 'package:aetheric/services/chat/screens/feedback_page.dart';

class FeedbackTile extends StatefulWidget {
  const FeedbackTile({super.key});

  @override
  State<FeedbackTile> createState() => _FeedbackTileState();
}

class _FeedbackTileState extends State<FeedbackTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeFeedbackPage(context),
      leading: const CircleAvatar(
        radius: 24.0,
        child: Icon(Icons.feedback),
      ),
      title: const Text(
        'Feedback',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Send us your thoughts'),
    );
  }

  _routeFeedbackPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }
}
