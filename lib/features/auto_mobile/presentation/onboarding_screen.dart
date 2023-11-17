import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/splash_screen_template.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/auto_home.dart';

class OnBoardingScreen extends StatefulWidget {

  const OnBoardingScreen({Key? key}) : super(key: key);

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
        return HomeRepositoryImpl.isAPILive().then(
          (val) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => val
                  ? const AutoHome()
                  : const SplashScreenTemplate(
                      label: "Beta Version: Soon to release"),
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
