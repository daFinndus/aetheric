import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:aetheric/services/auth/model/auth_expections.dart';

// This class contains all the functions for authentication
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthExceptions _authExceptions = AuthExceptions();

  // TODO: Right now the register page triggers everytime an error occurs
  // FIXME: This is not the best solution and should be fixed asap

  // Function for signing in the user
  Future signIn(BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        if (e.code == 'invalid-credential') {
          throw 'user-not-registered';
        } else {
          _showErrorFlushbar(context, e.code, e.code.toString());
        }
      }
    }
  }

  // Function for signing up the user
  Future signUp(BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        debugPrint('Error: $e');
        _showErrorFlushbar(context, e.code, e.toString());
      }
    }
  }

  // Function for signing out the user
  Future signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        debugPrint('Error: $e');
        _showErrorFlushbar(context, e.code, e.toString());
      }
    }
  }

  // Function for sending a password reset email
  Future resetPassword(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        debugPrint('Error: $e');
        _showErrorFlushbar(context, e.code, e.toString());
      }
    }
  }

  // Function for showing a flushbar with an error message
  void _showErrorFlushbar(
      BuildContext context, String errorCode, String errorMessage) {
    Flushbar(
      message: _authExceptions.errors.containsKey(errorCode)
          ? _authExceptions.errors[errorCode]
          : errorMessage,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromRGBO(230, 50, 50, 0.8),
    ).show(context);
  }
}
