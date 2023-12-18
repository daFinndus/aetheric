import 'package:flutter/material.dart';

class ThemeColors {
  final Color lightPrimaryColor = const Color.fromARGB(255, 43, 168, 177);
  final Color darkPrimaryColor = const Color.fromARGB(255, 36, 136, 143);

  final Color? brightColor = Colors.white;
  final Color? darkColor = Colors.grey[900];

  // This is what the user sees when light mode is enabled
  static ThemeData lightThemeData = ThemeData(
    primaryColor: ThemeData.light().primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeColors.lightPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.lightPrimaryColor,
    ),
    appBarTheme: AppBarTheme(backgroundColor: _themeColors.lightPrimaryColor),
    tabBarTheme: TabBarTheme(
      labelColor: _themeColors.brightColor,
      unselectedLabelColor: _themeColors.darkColor,
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        color: _themeColors.lightPrimaryColor,
      ),
    ),
  );

  // This here is what the user sees when enabling dark mode
  static ThemeData darkThemeData = ThemeData(
    primaryColor: Colors.grey[900],
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeColors.darkPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.darkPrimaryColor,
    ),
    appBarTheme: AppBarTheme(backgroundColor: _themeColors.darkPrimaryColor),
    tabBarTheme: TabBarTheme(
      labelColor: _themeColors.darkColor,
      unselectedLabelColor: _themeColors.brightColor,
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        color: _themeColors.darkPrimaryColor,
      ),
    ),
  );
}

ThemeColors _themeColors = ThemeColors();
