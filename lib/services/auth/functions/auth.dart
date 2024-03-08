import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:aetheric/services/auth/screens/login_page.dart';

// This class contains all the functions for authentication
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');
  late final CollectionReference _errorColl = _firestore.collection('errors');

  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final Reference _picRef = _storage.ref('profile_pictures');

  // Function for signing in the user
  Future signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Signing in user...');
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e is FirebaseAuthException) {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      } else {
        _errorColl.add({
          'type': e.runtimeType.toString(),
          'time': Timestamp.now(),
          'code': e.toString(),
          'location': 'Signing in user..',
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

      debugPrint('Signing up user...');
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e is FirebaseAuthException) {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      } else {
        _errorColl.add(
          {
            'type': e.runtimeType.toString(),
            'time': Timestamp.now(),
            'code': e.toString(),
            'location': 'Signing up user...',
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
          },
        );
      }
    }
  }

  // Function for signing out the user
  Future signOut() async {
    try {
      await _auth.signOut();
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage());
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e is FirebaseAuthException) {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      } else {
        _errorColl.add(
          {
            'type': e.runtimeType.toString(),
            'code': e.toString(),
          },
        );
      }
    }
  }

  // Function for sending a password reset email
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e is FirebaseAuthException) {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      } else {
        _errorColl.add(
          {
            'type': e.runtimeType.toString(),
            'time': Timestamp.now(),
            'code': e.toString(),
            'location': 'Sign in page, reset password...',
            'user': {
              'uid': _auth.currentUser?.uid,
              'email': email,
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
  }

  // Function for deleting the users account
  // This function really is complex, because we have to delete a lot of data
  // Because this function would get out of hand, we are not deleting messages
  Future deleteAccount() async {
    String uid = _auth.currentUser!.uid;

    try {
      // Attempt to delete auth entry
      await _auth.currentUser?.delete();
      debugPrint('Deleted auth entry...');

      // Delete the profile picture
      debugPrint('Going to delete profile picture...');
      await _picRef.child(uid).delete();
      debugPrint('Deleted profile picture out of storage.');

      // Attempt to delete database entry
      // After this, the user gets instantly thrown to the login page
      debugPrint('Going to delete db-entry with this uid: $uid');
      await _userColl.doc(uid).delete();
      debugPrint('Deleted database entry...');

      await _userColl.doc(uid).collection('invite_sent').get().then((snapshot) {
        for (DocumentSnapshot document in snapshot.docs) {
          document.reference.delete();

          // Delete our uid from their received invites
          _userColl
              .doc(document.id)
              .collection('invite_recv')
              .doc(uid)
              .delete();
        }
      });
      debugPrint('Deleted sent invites...');

      await _userColl.doc(uid).collection('invite_recv').get().then((snapshot) {
        for (DocumentSnapshot document in snapshot.docs) {
          document.reference.delete();

          // Delete our uid from their sent invites
          _userColl
              .doc(document.id)
              .collection('invite_sent')
              .doc(uid)
              .delete();
        }
      });
      debugPrint('Deleted received invites...');

      await _userColl.doc(uid).collection('contacts').get().then((snapshot) {
        for (DocumentSnapshot document in snapshot.docs) {
          document.reference.delete();

          // Delete our uid from their contacts
          _userColl.doc(document.id).collection('contacts').doc(uid).delete();
        }
      });
      debugPrint('Deleted contacts...');
    } catch (e) {
      debugPrint("${e.runtimeType} - ${e.toString()}");
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        // Rethrow the error for handling in our original page
        debugPrint('Rethrowing error...');
        rethrow;
      } else {
        _errorColl.add(
          {
            'type': e.runtimeType.toString(),
            'time': Timestamp.now(),
            'code': e.toString(),
            'location': 'Settings page, delete account...',
            'user': {
              'uid': _auth.currentUser?.uid,
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
  }
}
