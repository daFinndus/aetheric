import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/services/chat/backend/message_model.dart';

class MessageFunctions {
  final String chatId;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _errorColl = _firestore.collection('errors');
  late final CollectionReference _chatColl = _firestore.collection('chats');
  late final DocumentReference _docRef = _chatColl.doc(chatId);
  late final CollectionReference _messagesColl = _docRef.collection('messages');

  MessageFunctions({
    required this.chatId,
  });

  // Function for saving a messageModel in the database
  void sendMessage(MessageModel messageModel) {
    try {
      _messagesColl.add(messageModel.toMap());
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");

      _errorColl.add(
        {
          'type': e.runtimeType.toString(),
          'time': Timestamp.now(),
          'code': e.toString(),
          'location': 'Sending message...',
          'user': {
            'uid': _firebaseAuth.currentUser?.uid,
            'email': _firebaseAuth.currentUser?.email,
          },
          'device': {
            'name': Platform.localHostname,
            'os': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          }
        },
      );
    }
  }

  // Function for getting the messages from the database
  // They are ordered by timestamps in descending order
  Stream<QuerySnapshot> getMessages() {
    return _messagesColl.orderBy('datetime', descending: false).snapshots();
  }
}
