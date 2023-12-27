import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:aetheric/services/chat/backend/message_model.dart';

// Pass the _messageList as a parameter
class WebSocket with ChangeNotifier {
  final List<MessageModel> _messageList;

  WebSocket({required List<MessageModel> messageList})
      : _messageList = messageList;

  // While developing, the IP address is local - afterwards change it to the render server
  io.Socket socket = io.io("http://192.168.178.67:3000", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  void connectClient(String id) {
    socket.connect();
    socket.onConnect((data) => debugPrint('Successfully connected!'));
    socket.emit("/id", id);

    // Every received message is added to the message list
    socket.on('/message', (data) => setMessage('target', data));
  }

  void sendMessage(String message, String sourceId, String targetId) {
    setMessage('source', message);

    socket.emit(
      "/message",
      {
        'Message': message,
        'SourceId': sourceId,
        'TargetId': targetId,
      },
    );
  }

  void setMessage(
    String type,
    String message,
  ) {
    MessageModel messageModel = MessageModel(type: type, message: message);

    // TODO: Add message to database
    _messageList.add(messageModel);
  }
}
