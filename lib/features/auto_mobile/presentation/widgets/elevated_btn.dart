import 'package:flutter/material.dart';

ElevatedButton buildElevatedBtn(
  BuildContext context, {
  Key? key,
  Color? color,
  String label = '',
  Color? bgColor,
  Color? borderColor,
  double? elevation,
  EdgeInsets? padding,
  TextStyle textStyle = const TextStyle(),
  required void Function()? onPress,
  MaterialStatesController? buttonController,
}) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  Color tColor = colorScheme.surfaceTint;
  bgColor ??= colorScheme.primary;
  borderColor ??= tColor.withOpacity(0.1);

  return ElevatedButton(
    key: key,
    style: OutlinedButton.styleFrom(
      elevation: elevation,
      backgroundColor: bgColor,
      disabledBackgroundColor: tColor.withOpacity(0.4),
      side: BorderSide(color: borderColor),
      padding: padding,
    ),
    onPressed: onPress,
    statesController: buttonController,
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: textStyle.copyWith(
        color: color ?? Colors.white,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
