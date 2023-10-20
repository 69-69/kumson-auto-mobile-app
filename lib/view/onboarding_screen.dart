import 'package:automasters/service/api_service.dart';
import 'package:automasters/view/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../splash_screen_template.dart';
import '../utils/keyboard.dart';
import '../utils/size_config.dart';

class OnBoardingScreen extends StatefulWidget {
  // static const String routeName = "/onBoarding";
  final SharedPreferences? prefs;

  const OnBoardingScreen({this.prefs, Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // AppLifecycleState _appStatus = AppLifecycleState.detached;

  @override
  void initState() {
    homeScreen();
    super.initState();
  }

  void homeScreen() {
    /* Delay navigation for 1s, to show splashScreen logo */
    Future.delayed(
      const Duration(seconds: 2),
      () {
        return APIService().isAPIOnline().then(
              (val) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => val
                  ? const Home()
                  : const SplashScreenTemplate(label: "Beta Version: Soon to release"),
            ),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    KeyboardUtil.hide(context);
    // Show splashScreen while checking if SignedIn
    return const SplashScreenTemplate();
  }

// void getData() async => await Future.delayed(const Duration(seconds: 3));
/*FutureBuilder<dynamic> buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: GeneralService().isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          // Show splashScreen while checking if SignedIn
            return const SplashScreenTemplate();
          default:
            return (snapshot.hasData && snapshot.data.length > 0)
                ? const AppRoot()
                : const Body();
        }
      },
    );
  }*/
}
