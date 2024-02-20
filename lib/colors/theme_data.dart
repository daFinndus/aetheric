import 'package:flutter/material.dart';

class ThemeColors {
  final Color lightPrimaryColor = const Color.fromARGB(255, 49, 49, 49);
  final Color darkPrimaryColor = const Color.fromARGB(255, 231, 231, 231);

  final Color brightGrayColor = const Color.fromARGB(255, 242, 242, 242);
  final Color darkGrayColor = const Color.fromARGB(255, 33, 33, 33);

  final Color? brightColor = Colors.white;
  final Color? darkColor = Colors.grey[900];

  // This is what the user sees when light mode is enabled
  static ThemeData lightThemeData = ThemeData(
    primaryColor: _themeColors.lightPrimaryColor,
    secondaryHeaderColor: _themeColors.darkPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: _themeColors.lightPrimaryColor,
      onPrimary: _themeColors.darkPrimaryColor,
      secondary: _themeColors.darkPrimaryColor,
      onSecondary: _themeColors.lightPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.lightPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(color: _themeColors.lightPrimaryColor),
      iconTheme: IconThemeData(color: _themeColors.lightPrimaryColor),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: _themeColors.brightColor,
      unselectedLabelColor: _themeColors.brightColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
    ),
  );

  // This here is what the user sees when enabling dark mode
  static ThemeData darkThemeData = ThemeData(
    primaryColor: _themeColors.darkPrimaryColor,
    secondaryHeaderColor: _themeColors.lightPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: _themeColors.darkPrimaryColor,
      onPrimary: _themeColors.lightPrimaryColor,
      secondary: _themeColors.lightPrimaryColor,
      onSecondary: _themeColors.darkPrimaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeColors.darkPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(color: _themeColors.darkPrimaryColor),
      iconTheme: IconThemeData(color: _themeColors.darkPrimaryColor),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: _themeColors.brightColor,
      unselectedLabelColor: _themeColors.brightColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
    ),
  );
}

ThemeColors _themeColors = ThemeColors();
