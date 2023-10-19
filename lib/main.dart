import 'package:automasters/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_schemes.g.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());

  // Disable screen orientation to PORTRAIT-UP ONLY
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Force System UI to use my defined colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.poppinsTextTheme(),

        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
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
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),

      // theme: ThemeData.light(useMaterial3: true,),
      //darkTheme: DarkTheme.darkTheme,
      // themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
/*
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        // This is the theme of your application.

        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA10808),
          primary: const Color(0xFFA10808),
          //onPrimary: const Color(0xFFA10808),
        ),

        appBarTheme: const AppBarTheme(backgroundColor:  Color(0xFFA10808)),

        cardTheme: const CardTheme(color: Color(0xFFF0EEF6)),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),*/
