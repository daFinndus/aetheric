import 'package:sizer/sizer.dart';
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
  late final DateTime _datetime = DateTime.parse(widget.datetime).toLocal();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          margin: const EdgeInsets.only(left: 6.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SizerUtil.width * 0.7,
              ),
              child: Stack(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        bottom: 24.0,
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
          ),
        );
      },
    );
  }
}
