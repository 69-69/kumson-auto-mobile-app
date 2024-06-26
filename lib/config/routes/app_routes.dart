import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/index.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case appRootRoute:
        return _materialRoute(Welcome(activeSignup: settings.arguments as SignupModel?));

      /*case dashboardRoute:
        return _materialRoute(const Dashboard());*/

      case autoHomeRoute:
        return _materialRoute(const AutoHome());

      case autoHomeWithAuthRoute:
        return _materialRoute(
          AutoHomeWithAuth(activeSignup: settings.arguments as SignupModel?),
        );

      case splashScreenRoute:
        return _materialRoute(
          SplashScreen(label: settings.arguments as String),
        );

      case listAllParts:
        return _materialRoute(
          ListAllParts(map: settings.arguments as Map<String, dynamic>),
        );

      case partsByPartNoRoute:
        return _materialRoute(
          PartsByPartNo(list: settings.arguments as List),
        );

      case vehicleDetailsRoute:
        return _materialRoute(
          VehicleDetails(map: settings.arguments as Map<String, dynamic>),
        );

      case partDetailsCheckout:
        return _materialRoute(
          PartDetailsCheckout(map: settings.arguments as Map<String, dynamic>),
        );

      case partsCrossRef:
        return _materialRoute(
          PartsCrossRef(map: settings.arguments as Map<String, dynamic>),
        );

      case partsByPrice:
        return _materialRoute(
          PartsByPrice(map: settings.arguments as Map<String, dynamic>),
        );

      case otpPhoneNumberFrom:
        return _materialRoute(
          OTPPhoneNumberFrom(title: settings.arguments as dynamic),
        );

      default:
        return _materialRoute(const SplashScreen());
    }
  }

// final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

  /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PartsByPartNo(hunters: (state.hunters as List<HunterModel>))),
                (Route<dynamic> route) => false,
          );*/
  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view, fullscreenDialog: true);
  }
}
