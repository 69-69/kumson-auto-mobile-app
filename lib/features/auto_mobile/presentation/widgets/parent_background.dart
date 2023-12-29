import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';

class ParentBackground extends StatelessWidget {
  const ParentBackground({
    super.key,
    required this.child,
    this.addScroll = true,
  });

  final Widget child;
  final bool addScroll;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        /*gradient: LinearGradient(
          colors: [Colors.white, Colors.red.shade100, Colors.white],
        ),*/
        image: DecorationImage(
          image: AssetImage(appHomeBg),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      height: SizeConfig.screenHeight!,
      width: SizeConfig.screenWidth!,
      child: addScroll ? _buildScroll() : buildContainer(),
    );
  }

  SingleChildScrollView _buildScroll() {
    return SingleChildScrollView(
      primary: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
      /*decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 8,
          )
        ],
      ),*/
      margin: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: SizeConfig.screenHeight! / 14,
      ),
      child: child,
    );
  }
}
