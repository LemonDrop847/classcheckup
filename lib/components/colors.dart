import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      secondary: Colors.cyan,
      background: Colors.white,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.deepPurple,
    colorScheme: ColorScheme.dark(
      secondary: Colors.deepPurpleAccent,
      background: Colors.black,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
  );

  static bool isDarkTheme = false;

  static Future<void> loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  }

  static void setTheme(bool isDark) {
    isDarkTheme = isDark;
  }

  static Future<void> saveThemePreference(bool isDarkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
    setTheme(isDarkTheme);
  }

  static ThemeData get currentTheme => isDarkTheme ? darkTheme : lightTheme;
}
