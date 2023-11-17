import 'package:flutter/material.dart';

OutlinedButton buildOutlinedBtn(
  BuildContext context, {
  Color? color,
  Color? borderColor,
  String label = '',
  required void Function()? onPress,
  MaterialStatesController? buttonController,
}) {
  Color tColor = color ?? Theme.of(context).colorScheme.surfaceTint;

  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor ?? tColor),
    ),
    onPressed: onPress,
    statesController: buttonController,
    child: Text(label, style: TextStyle(color: tColor)),
  );
}
