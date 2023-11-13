import 'package:flutter/material.dart';

ThemeData buildThemeData(BuildContext context, {required ColorScheme cs}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,

    // textTheme: GoogleFonts.poppinsTextTheme(),
    // expansionTileTheme: const ExpansionTileThemeData(),

    appBarTheme: AppBarTheme(
      backgroundColor: cs.primary,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        borderRadius: BorderRadius.circular(7),
      ),
      // focusColor:  Color(0xFFBA1A1A)
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
    ),
    // primarySwatch: Colors.red,
  );
}