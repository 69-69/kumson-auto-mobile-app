import 'package:flutter/material.dart';

ThemeData buildThemeData(BuildContext context, {required ColorScheme cs}) {
  double radius = 30.0;

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
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        borderRadius: BorderRadius.circular(radius),
      ),
      // focusColor:  Color(0xFFBA1A1A)
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1.0),
        shape: const StadiumBorder(),
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),*/
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),*/
      ),
    ),
    // primarySwatch: Colors.red,
  );
}
