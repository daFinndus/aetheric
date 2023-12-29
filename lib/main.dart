import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aetheric/services/auth/screens/login_page.dart';
import 'package:aetheric/colors/theme_data.dart';
import 'package:aetheric/screens/tab_page.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
            if (snapshot.hasData) {
              return const TabPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
