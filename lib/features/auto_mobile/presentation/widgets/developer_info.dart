import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';


class DeveloperInfo extends StatelessWidget {
  const DeveloperInfo({
    Key? key,
    this.padding,
    this.margin,
    this.fontSize,
  }) : super(key: key);

  final double? fontSize;
  final EdgeInsets? padding, margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20.0),
      margin: margin ?? const EdgeInsets.only(bottom: 50),
      child: Text.rich(
        TextSpan(
          text: 'By: ',
          style: const TextStyle(color: Color(0xFFB1B3B8)),
          children: [
            TextSpan(
              text: 'assignDevelopers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: getProportionateScreenWidth(fontSize ?? 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
