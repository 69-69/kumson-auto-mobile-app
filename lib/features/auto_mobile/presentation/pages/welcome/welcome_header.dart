import 'package:automasters/core/constants/constants.dart';
import 'package:flutter/material.dart';



class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return _buildHeader(context, scaffoldKey);
  }

  Row _buildHeader(
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _menuButton(scaffoldKey, context),
        Text(
          appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton.filled(
          // style: ButtonStyle(shape: MaterialStateProperty.),
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
        )
      ],
    );
  }

  IconButton _menuButton(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu,
        size: 35,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          //close drawer, if drawer is open
          scaffoldKey.currentState!.closeDrawer();
        } else {
          //open drawer, if drawer is closed
          scaffoldKey.currentState!.openDrawer();
        }
      },
    );
  }
}