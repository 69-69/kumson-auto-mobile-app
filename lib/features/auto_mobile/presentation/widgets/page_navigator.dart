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
      child: Container(
        height: getProportionateScreenHeight(30.0),
        width: getProportionateScreenWidth(30.0),
        padding: const EdgeInsets.fromLTRB(5.0, 1.0, 0, 1.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.3),
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        ),
        child: Icon(
          Icons.adaptive.arrow_back,
          color: const Color(0xFFFFFFFF),
          size: 20,
        ),
      ),
    );
