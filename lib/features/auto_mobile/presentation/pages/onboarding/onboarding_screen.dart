import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/splash/splash_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    homeScreen();
    super.initState();
  }

  void homeScreen() {
    // Delay navigation for 1s, to show splashScreen
    /*Future.delayed(
      const Duration(seconds: 2),
      () {
        return HomeRepositoryImpl.isAPILive().then(
          (val) {
            return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => val
                    ? const AutoHome()
                    : const SplashScreen(
                        label: "Beta Version: Soon to release"),
              ),
            );
          },
        );
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    // Call SizeConfig on your starting screen
    SizeConfig().init(context);
    // KeyboardUtil.hide(context);

    // Show splashScreen while checking if SignedIn
    return const SplashScreen();
  }
}
