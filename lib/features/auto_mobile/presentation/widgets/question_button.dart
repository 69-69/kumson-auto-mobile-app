import 'package:flutter/material.dart';

buildQuestionButton(BuildContext context,
    {void Function()? onPress, Color? bgColor, Color? color, IconData? icon}) {
  ColorScheme theme = Theme.of(context).colorScheme;

  return SizedBox(
    width: 30.0,
    height: 30.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? theme.onInverseSurface,
        padding: EdgeInsets.zero,
        shape: CircleBorder(
          side: BorderSide(color: color ?? theme.surfaceTint),
        ),
      ),
      onPressed: onPress,
      child: Icon(
        icon ?? Icons.question_mark_sharp,
        color: color ?? theme.surfaceTint,
        size: 20,
      ),
    ),
  );
}
