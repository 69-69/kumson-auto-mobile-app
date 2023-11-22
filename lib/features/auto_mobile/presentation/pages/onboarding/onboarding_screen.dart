import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/auth_repository.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/splash/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
// import 'package:automasters/features/auto_mobile/presentation/pages/home/auto_home.dart';

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
    BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      switch (state.status) {
        case AuthStatus.authenticated:
          pageNavigator(context, routeName: autoHomeRoute, clearStack: true);
        case AuthStatus.unauthenticated:
          pageNavigator(context, routeName: autoHomeRoute, clearStack: true);
        case AuthStatus.unknown:
          break;
      }
    });
    /* Delay navigation for 1s, to show splashScreen logo */
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
    // You have to call it on your starting screen
    SizeConfig().init(context);

    KeyboardUtil.hide(context);
    // Show splashScreen while checking if SignedIn
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            pageNavigator(context, routeName: autoHomeRoute, clearStack: true);
          case AuthStatus.unauthenticated:
            pageNavigator(context, routeName: autoHomeWithAuthRoute, clearStack: true);
          case AuthStatus.unknown:
            break;
        }
      },
      child: const SplashScreen(),
    );
    // return const SplashScreen();
  }
}
