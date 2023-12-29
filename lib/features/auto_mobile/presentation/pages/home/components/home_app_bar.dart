import 'package:automasters/core/constants/constants.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.onPress,
    this.actionWidget,
    this.bgColor,
  });

  final Function()? onPress;
  final Widget? actionWidget;
  final Color? bgColor;

  // implement preferredSize
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return buildAppBar(context);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bgColor ?? Theme.of(context).colorScheme.primary,
      // iconTheme: IconThemeData(color: Colors.white,size: 30,),
      leading: _menuButton(context),
      title: const Text(
        appName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 32.0,
          color: Color(0xFFD3AFAE),
          height: 1.3,
        ),
      ),
      actions: [
        actionWidget ??
            IconButton.filled(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
      ],
      bottom: _appBarBottomCard(context),
    );
  }

  IconButton _menuButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.menu,
        size: 35,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      onPressed: onPress,
    );
  }

  PreferredSize _appBarBottomCard(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        width: double.infinity,
        color: Colors.black26,
        padding: const EdgeInsets.all(1),
        child: Text(
          appSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
