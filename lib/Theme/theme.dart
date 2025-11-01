import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Mode
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),

  textTheme: TextTheme(
    headlineLarge: GoogleFonts.kanit(fontSize: 50, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.lato(fontSize: 20),
    displayLarge: GoogleFonts.prompt(fontSize: 30, fontWeight: FontWeight.bold),
  ),
);

// Dark Mode
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.kanit(fontSize: 50, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.lato(fontSize: 20),
    displayLarge: GoogleFonts.prompt(fontSize: 30, fontWeight: FontWeight.bold),
  ),
);
