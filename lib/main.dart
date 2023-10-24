import 'package:automasters/service/change_notifier_service.dart';
import 'package:automasters/view/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'color_schemes.g.dart';
import 'package:google_fonts/google_fonts.dart';

/*class MyHttpOverrides extends HttpOverrides {
  // Note: to Override HTTPS security ->  ByPass https security for development only(disable when in prod.)
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

void main() {
  // Note: to Override HTTPS security -> for dev only
  // HttpOverrides.global = MyHttpOverrides();

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
              theme: buildThemeData(context),

              darkTheme: buildThemeData(context, cs: darkColorScheme),

              // theme: ThemeData.light(useMaterial3: true,),
              //darkTheme: DarkTheme.darkTheme,
              // themeMode: ThemeMode.system,
              home: const OnBoardingScreen(),
            ));
  }

  ThemeData buildThemeData(BuildContext context, {ColorScheme? cs}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs ?? lightColorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(),

      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
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
}
