import 'package:automasters/features/auto_mobile/presentation/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';

orSeparator({Color? lineColor, Color? textColor, String? text}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HorizontalLine(width: 4, color: lineColor ?? Colors.white54),
        Text(
          text ?? 'OR',
          style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.bold),
        ),
        HorizontalLine(width: 4, color: lineColor ?? Colors.white54),
      ],
    );
