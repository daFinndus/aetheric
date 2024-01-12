import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This class contains all the functions for authentication
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');
  late final CollectionReference _errorColl = _firestore.collection('errors');

  // Function for signing in the user
  Future signIn(String email, String password) async {
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
          'time': Timestamp.now(),
          'code': e.toString(),
          'user': {
            'uid': _auth.currentUser?.uid,
            'email': email,
            'password': password,
          },
          'device': {
            'name': Platform.localHostname,
            'os': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          }
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  // Function for signing up the user
  Future signUp(String email, String password) async {
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
          'time': Timestamp.now(),
          'code': e.toString(),
          'user': {
            'uid': _auth.currentUser?.uid,
            'email': email,
            'password': password,
          },
          'device': {
            'name': Platform.localHostname,
            'os': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          }
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  // Function for signing out the user
  Future signOut() async {
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
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e.runtimeType != FirebaseAuthException) {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'time': Timestamp.now(),
          'code': e.toString(),
          'user': {
            'uid': _auth.currentUser?.uid,
            'email': email,
          },
          'device': {
            'name': Platform.localHostname,
            'os': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          }
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        rethrow;
      }
    }
  }

  Future deleteAccount() async {
    try {
      // Attempt to delete database entry
      debugPrint('Uid: ${_auth.currentUser?.uid}');
      await _userColl.doc(_auth.currentUser?.uid).delete();
      debugPrint('Deleted database entry...');

      // Attempt to delete auth entry
      await _auth.currentUser?.delete();
      debugPrint('Deleted auth entry...');
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");

      if (e.runtimeType != FirebaseAuthException) {
        String location = e.runtimeType == FirebaseAuthException
            ? 'auth.dart - deleteAccount() - auth.currentUser.delete()'
            : 'auth.dart - deleteAccount() - userColl.doc().delete()';

        _errorColl.add({
          'type': e.runtimeType.toString(),
          'time': Timestamp.now(),
          'code': e.toString(),
          'location': location,
          'user': {
            'uid': _auth.currentUser?.uid,
          },
          'device': {
            'name': Platform.localHostname,
            'os': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          }
        });
      } else if (e.runtimeType == FirebaseAuthException) {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      }
    }
  }
}
