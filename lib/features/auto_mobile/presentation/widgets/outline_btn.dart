import 'package:flutter/material.dart';

OutlinedButton buildOutlinedBtn(
  BuildContext context, {
  Key? key,
  Color? color,
  Color? bgColor,
  Color? borderColor,
  String label = '',
  TextStyle textStyle = const TextStyle(),
  required void Function()? onPress,
  MaterialStatesController? buttonController,
}) {
  Color tColor = color ?? Theme.of(context).colorScheme.surfaceTint;

  return OutlinedButton(
    key: key,
    style: OutlinedButton.styleFrom(
      backgroundColor: bgColor,
      side: BorderSide(color: borderColor ?? tColor),
    ),
    onPressed: onPress,
    statesController: buttonController,
    child: Text(
      label,
      style: textStyle.copyWith(
        color: color,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
