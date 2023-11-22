import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/index.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case autoHomeRoute:
        return _materialRoute(const AutoHome());

      case autoHomeWithAuthRoute:
        return _materialRoute(const AutoHomeWithAuth());

      case splashScreenRoute:
        return _materialRoute(
          SplashScreen(label: settings.arguments as String),
        );

      case listAllParts:
        return _materialRoute(
          ListAllParts(data: settings.arguments as Map<String, dynamic>),
        );

      case partsByPartNoRoute:
        return _materialRoute(
          PartsByPartNo(hunters: settings.arguments as List<HunterModel>),
        );

      // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
      case vehicleDetailsRoute:
        return _materialRoute(
          VehicleDetails(data: settings.arguments as Map<String, dynamic>),
        );

      case partDetailsCheckout:
        return _materialRoute(
          PartDetailsCheckout(data: settings.arguments as Map<String, dynamic>),
        );

      case partsCrossRef:
        return _materialRoute(
          PartsCrossRef(data: settings.arguments as Map<String, dynamic>),
        );

      case partsByPrice:
        return _materialRoute(
          PartsByPrice(data: settings.arguments as Map<String, dynamic>),
        );

      default:
        return _materialRoute(const AutoHome());
    }
  }

  /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PartsByPartNo(hunters: (state.hunters as List<HunterModel>))),
                (Route<dynamic> route) => false,
          );*/
  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
