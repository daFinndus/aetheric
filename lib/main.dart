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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

// TODO: Fix contact tile
// TODO: Fix profile page
// FIXME: There are some issues with SizerUtil
// TODO: Add send image and audio function
// TODO: Implement push notifications
// TODO: Implement spotify API

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
              if (!snapshot.hasData) {
                debugPrint('Staying on GreetPage..');
                return const GreetPage();
              } else {
                debugPrint('Going into registration check..');
                // Check if user has registered their personal data
                return FutureBuilder(
                  future: _checkRegistration(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == true) {
                        debugPrint('User is registered..');
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
