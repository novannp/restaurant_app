import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Theme.of(context).canvasColor,
      // // For Material 3
      // useMaterial3: true,
      cardTheme: CardTheme(
        elevation: 0,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      primarySwatch: Colors.amber,
      textTheme: TextTheme(
        headline1: GoogleFonts.openSans(
            fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: GoogleFonts.openSans(
            fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3:
            GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.openSans(
            fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5:
            GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.openSans(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.openSans(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
