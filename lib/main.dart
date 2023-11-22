import 'package:automasters/auto_mobile_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:automasters/features/injection_container.dart';

/*class MyHttpOverrides extends HttpOverrides {
  // Note: to Override HTTPS security ->  ByPass https security for development only(disable when in prod.)
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

Future<void> main() async {
  // Note: to Override HTTPS security -> for dev only
  // HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(const AutoMobileApp());

  // Disable screen orientation to PORTRAIT-UP ONLY
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Force System UI to use my defined colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

