import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.white
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        // for app bar title
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 18,
      ),
      bodyMedium: TextStyle(
        // for movie title
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        // for release date
        fontSize: 12,
        color: Colors.grey,
      ),
    ),
  );
}
