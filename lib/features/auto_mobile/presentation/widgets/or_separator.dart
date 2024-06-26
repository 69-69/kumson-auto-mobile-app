import 'package:automasters/features/auto_mobile/presentation/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';

orSeparator({
  Color? lineColor,
  Color? textColor,
  Color? bgColor,
  dynamic label,
  double? iconSize,
}) {
  final txt = label is IconData
      ? Icon(label, size: iconSize)
      : Text(
          label ?? 'OR',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      HorizontalLine(width: 4, color: lineColor ?? Colors.white54),
      bgColor != null
          ? Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.pink, offset: Offset(0, -1), blurRadius: 8)
                ],
              ),
              child: txt,
            )
          : txt,
      HorizontalLine(width: 4, color: lineColor ?? Colors.white54),
    ],
  );
}
