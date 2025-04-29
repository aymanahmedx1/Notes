import 'package:flutter/material.dart';

class CustomTheme {
  // If you want to modify both themes at once, modify the colors below.

  static const Color _primaryColor = Color(0xFF000000);
  static const Color _primaryInverseColor = Color(0xFF4E432F);
  static const Color _onSurfaceColor = Color(0xFF000000);
  static const Color _onSurfaceVariant = Color(0xFFFF6578);
  static const Color _onPrimaryColor = Color(0xFFA5E179);
  static const Color _surfaceColor = Colors.white; //Color(0xFF646464);
  static const Color _backgroundColor = Color(0xFFffffff);
  static const Color _onSecondaryColor = Color(0xFFE1E3E4);
  static const Color _onBackgroundColor = Color(0xFF828A9A);
  static const Color _secondaryColor = Color(0xFF55393D);
  static const Color _primaryContainer = Color(0xFF394634);
  static const Color _errorColor = Color(0xFFF69C5E);
  static const Color _onErrorColor = Color(0xFF354157);
  static const Color _onOrangColor = Color(0xffff4702);
  static const Color _myColor = Color (0xffd81b60) ;



  // If you want to modify the light theme only, modify the colors below.

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    disabledColor: _primaryColor,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _primaryColor,
      background: _backgroundColor,
      primary: _primaryColor,
      secondary: _secondaryColor,
      inversePrimary: _primaryInverseColor,
      onSurface: _onSurfaceColor,
      surface: _surfaceColor,
      onSurfaceVariant: _onSurfaceVariant,
      onPrimary: _onPrimaryColor,
      onSecondary: _onSecondaryColor,
      onBackground: _onBackgroundColor,
      primaryContainer: _primaryContainer,
      error: _errorColor,
      onError: _onErrorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: _onOrangColor)),
    iconTheme: const IconThemeData(color: _onOrangColor),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.red,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 3)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 3)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 3)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 3)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 3)),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: _backgroundColor,
    ),
    datePickerTheme:
        const DatePickerThemeData(backgroundColor: _backgroundColor),
  );

  // If you want to modify the dark theme only, modify the colors below.

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _primaryColor,
      background: _backgroundColor,
      primary: _primaryColor,
      secondary: _secondaryColor,
      inversePrimary: _primaryInverseColor,
      onSurface: _onSurfaceColor,
      surface: _surfaceColor,
      onSurfaceVariant: _onSurfaceVariant,
      onPrimary: _onPrimaryColor,
      onSecondary: _onSecondaryColor,
      onBackground: _onBackgroundColor,
      primaryContainer: _primaryContainer,
      error: _errorColor,
      onError: _onErrorColor,
    ),
  );

  static const textMoreStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}
