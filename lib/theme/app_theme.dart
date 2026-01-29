import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF005b96);
  
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.grey[100],

    textTheme: GoogleFonts.montserratTextTheme(), 

    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white, 
        fontSize: 20, 
        fontWeight: FontWeight.bold
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      prefixIconColor: primary,
    ),
  );
}