import 'package:flutter/material.dart';

ElevatedButton buildElevatedBtn(BuildContext context, {
  Key? key,
  Color? color,
  String label = '',
  Color? borderColor,
  required void Function()? onPress,
  MaterialStatesController? buttonController,
}) {
  Color tColor = color ?? Theme
      .of(context)
      .colorScheme
      .surfaceTint;

  return ElevatedButton(
    key: key,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor ?? tColor.withOpacity(0.3)),
    ),
    onPressed: onPress,
    statesController: buttonController,
    child: Text(label, style: TextStyle(color: tColor)),
  );
}
