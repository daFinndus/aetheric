import 'package:flutter/material.dart';

class ThemeColors {
  final Color lightPrimaryColor = const Color.fromARGB(255, 49, 49, 49);
  final Color darkPrimaryColor = const Color.fromARGB(255, 231, 231, 231);

  final Color? brightColor = Colors.white;
  final Color? darkColor = Colors.grey[900];

  // This is what the user sees when light mode is enabled
  static ThemeData lightThemeData = ThemeData(
    primaryColor: _themeColors.lightPrimaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeColors.lightPrimaryColor,
      secondary: _themeColors.darkPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.lightPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _themeColors.lightPrimaryColor,
      titleTextStyle: TextStyle(color: _themeColors.darkPrimaryColor),
      iconTheme: IconThemeData(color: _themeColors.darkPrimaryColor),
    ),
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
    primaryColor: _themeColors.darkPrimaryColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeColors.darkPrimaryColor,
      secondary: _themeColors.lightPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.darkPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _themeColors.darkPrimaryColor,
      titleTextStyle: TextStyle(color: _themeColors.lightPrimaryColor),
      iconTheme: IconThemeData(color: _themeColors.lightPrimaryColor),
    ),
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
