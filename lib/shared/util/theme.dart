import 'package:flutter/material.dart';
import 'color.dart';

ThemeData myTheme = ThemeData(
  primaryColor: cMain,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: cMain),
    bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: cMain),
    bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: cMain),
    labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    displayMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    displaySmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    headlineLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
  ),
  appBarTheme: const AppBarTheme(
    color: cSecondColor,
    titleTextStyle: TextStyle(
      color: cWhite,
      fontFamily: 'Poppins',
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    centerTitle: true,
    iconTheme: IconThemeData(color: cWhite),
  ),
  scaffoldBackgroundColor: cWhite,
  iconTheme: const IconThemeData(color: cSecondColor),
  primaryIconTheme: const IconThemeData(color: cSecondColor),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(primary: cSecondColor),
    textTheme: ButtonTextTheme.normal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(cSecondColor),
        foregroundColor: MaterialStateProperty.all(Colors.white)),
  ),
);
