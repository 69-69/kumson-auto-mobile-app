import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({
    Key? key,
    this.color,
    required this.width,
    this.thickness = 1,
  }) : super(key: key);

  final Color? color;
  final double width;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      width: SizeConfig.screenWidth! / width,
      height: thickness,
      color: color ?? Colors.grey,
    );
  }
}
