import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class MessageSender extends StatefulWidget {
  final String message;
  final String datetime;

  const MessageSender({
    super.key,
    required this.message,
    required this.datetime,
  });

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  late final DateTime _datetime = DateTime.parse(widget.datetime).toLocal();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: SizerUtil.width * 0.7,
            ),
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 24.0,
                      left: 16.0,
                      right: 48.0,
                    ),
                    child: Text(
                      widget.message,
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
                          '${_datetime.hour < 10 ? '0' : ''}${_datetime.hour}:${_datetime.minute < 10 ? '0' : ''}${_datetime.minute}',
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
      },
    );
  }
}
