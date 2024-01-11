import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aetheric/screens/tab_page.dart';
import 'package:aetheric/colors/theme_data.dart';
import 'package:aetheric/services/auth/screens/login_page.dart';
import 'package:aetheric/services/auth/screens/data_personal_name_page.dart';

// TODO: Strip down text field entries, cause they sometimes cause errors
// TODO: Clear time from birthday datetime object

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FIXME: This here doesnt work on web
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
          builder: (context, authSnapshot) {
            // Check if user is logged in
            if (authSnapshot.hasData) {
              // Check if user has completed registration
              return FutureBuilder(
                future: _checkRegistration(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return const TabPage();
                    } else {
                      return const DataPersonalNamePage();
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return const LoginPage();
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
