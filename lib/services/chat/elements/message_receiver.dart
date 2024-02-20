import 'package:flutter/material.dart';

class MessageReceiver extends StatefulWidget {
  final String message;
  final String datetime;

  const MessageReceiver({
    super.key,
    required this.message,
    required this.datetime,
  });

  @override
  State<MessageReceiver> createState() => _MessageReceiverState();
}

class _MessageReceiverState extends State<MessageReceiver> {
  late DateTime _datetime = DateTime.parse(widget.datetime);

  @override
  void initState() {
    super.initState();

    _datetime = _datetime.toLocal();
  }

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
                  bottom: 32.0,
                  left: 16.0,
                  right: 48.0,
                ),
                child: Text(
                  widget.message,
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
                '${_datetime.hour < 10 ? '0' : ''}${_datetime.hour}:${_datetime.minute < 10 ? '0' : ''}${_datetime.minute}',
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
