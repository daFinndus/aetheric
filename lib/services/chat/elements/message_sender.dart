import 'package:flutter/material.dart';

class MessageSender extends StatelessWidget {
  final String message;

  const MessageSender({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 24.0,
                  left: 12.0,
                  right: 32.0,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Positioned(
                bottom: 6.0,
                right: 10.0,
                child: Row(
                  children: [
                    Text(
                      '12:00',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.done_all,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
