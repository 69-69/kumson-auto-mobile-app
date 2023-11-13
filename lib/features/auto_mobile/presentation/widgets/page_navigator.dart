import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';

pageNavigator(BuildContext context, {String? routeName, Object? arguments}) {
  routeName != null
      ? Navigator.pushNamed(
          context,
          routeName,
          arguments: arguments,
        )
      : Navigator.of(context).pop();
}

/*final canPop = Navigator.canPop(context);
final rootNavigator = Navigator.of(context, rootNavigator: true);
canPop
? rootNavigator.pop(isSearching = false)
    : Navigator.pushReplacementNamed(context, appRootRoute);
rootNavigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)*/

buildBackButton(BuildContext context, {String? routeName, Object? arguments}) =>
    InkWell(
      onTap: () => pageNavigator(
        context,
        routeName: routeName,
        arguments: arguments,
      ),
      child: SizedBox(
        height: getProportionateScreenHeight(60.0),
        width: getProportionateScreenWidth(60.0),
        child: Icon(
          Icons.adaptive.arrow_back,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
