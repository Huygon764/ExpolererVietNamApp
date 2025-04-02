import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1)
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    dividerColor: const Color.fromARGB(255, 216, 216, 216),
    iconTheme: IconThemeData(color: Colors.blue),
    cardColor: Colors.grey[100]
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF5e5e5e),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      shadowColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF272727),
      selectedItemColor: Colors.blue[200],
      unselectedItemColor: Colors.grey[400],
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    dividerColor: const Color.fromARGB(255, 26, 26, 26),
    iconTheme: IconThemeData(color: Colors.blue[200]),
    cardColor: Colors.grey[800]
  );
}
