import 'package:flutter/material.dart';

class MessageReceiver extends StatelessWidget {
  final String message;

  const MessageReceiver({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Stack(
          children: [
            Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 24.0,
                  left: 12.0,
                  right: 32.0,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6.0,
              right: 10.0,
              child: Text(
                '12:00',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
