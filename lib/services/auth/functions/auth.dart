import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';

// This class contains all the functions for authentication
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
          _showErrorFlushbar(context, e.toString());
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
        _showErrorFlushbar(context, e.toString());
      }
    }
  }

  // Function for signing out the user
  Future signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (context.mounted) {
        debugPrint('Error: $e');
        _showErrorFlushbar(context, e.toString());
      }
    }
  }

  // Function for sending a password reset email
  Future resetPassword(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (context.mounted) {
        debugPrint('Error: $e');
        _showErrorFlushbar(context, e.toString());
      }
    }
  }

  // Display snackbar for errors
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromRGBO(230, 50, 50, 0.8),
      ),
    );
  }

  // This is way cooler than the snackbar
  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromRGBO(230, 50, 50, 0.8),
    ).show(context);
  }
}
