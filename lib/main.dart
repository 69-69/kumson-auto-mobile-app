import 'package:automasters/service/change_notifier_service.dart';
import 'package:automasters/view/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChangeNotifierService()),
        ],
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildThemeData(),

              darkTheme: buildThemeData(cs: darkColorScheme),

              // theme: ThemeData.light(useMaterial3: true,),
              //darkTheme: DarkTheme.darkTheme,
              // themeMode: ThemeMode.system,
              home: const OnBoardingScreen(),
            ));
  }

  ThemeData buildThemeData({ColorScheme? cs}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs ?? lightColorScheme,
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
}
