import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFEB5B00),
    secondary: Color(0xFFFFC25F),
    outline: Colors.grey.shade100,
    tertiary: Color.fromARGB(255, 0, 0, 0),
    // ignore: deprecated_member_use
    background: Color.fromARGB(255, 255, 195, 92),
    inversePrimary: Color.fromARGB(255, 42, 131, 58),
    onPrimary: Colors.white,
    onSecondary: Color(0xFF7E1891),
    error: Color(0xFFD91656),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.orange),
    labelLarge: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black26),
    bodySmall: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFEB5B00),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  useMaterial3: true,
);
