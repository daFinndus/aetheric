import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aetheric/colors/theme_data.dart';

import 'package:aetheric/screens/tab_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const Scaffold(
        body: TabPage(),
      ),
    );
  }
}
