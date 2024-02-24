import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/screens/tab_page.dart';
import 'package:aetheric/colors/theme_data.dart';
import 'package:aetheric/services/auth/screens/greet_page.dart';
import 'package:aetheric/services/auth/screens/data_personal_name_page.dart';

// TODO: Add notifications for new messages
// TODO: Manage contacts by user id
// TODO: Audio messages
// TODO: Lock app with fingerprint or face recognition
// TODO: Homepage should be a feed of the user's contacts and more
// TODO: Look at spotify api to show what the user is listening to

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersColl = _firestore.collection('users');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Aetheric',
      themeMode: ThemeMode.system,
      theme: ThemeColors.lightThemeData,
      darkTheme: ThemeColors.darkThemeData,
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if user is signed in
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return const GreetPage();
              } else {
                // Check if user has registered their personal data
                return FutureBuilder(
                  future: _checkRegistration(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == true) {
                        return const TabPage();
                      } else {
                        return const DataPersonalNamePage();
                      }
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Search for a certain data entry in the users collection
  Future<bool> _checkRegistration() async {
    final User? user = _auth.currentUser;
    final DocumentSnapshot userDoc = await _usersColl.doc(user!.uid).get();

    if (userDoc.exists) {
      return true;
    } else {
      return false;
    }
  }
}
