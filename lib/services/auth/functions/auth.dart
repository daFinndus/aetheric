import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This class contains all the functions for authentication
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _errorColl = _firestore.collection('errors');

  // Function for signing in the user
  Future signIn(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e.runtimeType != FirebaseAuthException) {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'code': e.toString(),
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  // Function for signing up the user
  Future signUp(BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e.runtimeType != FirebaseAuthException) {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'code': e.toString(),
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  // Function for signing out the user
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e.runtimeType != FirebaseAuthException) {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'code': e.toString(),
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  // Function for sending a password reset email
  Future resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e.runtimeType != FirebaseAuthException) {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'code': e.toString(),
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }
}
