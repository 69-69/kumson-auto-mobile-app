import 'package:flutter/material.dart';

customCard({Color? color, ShapeBorder? shape, required Widget child}) => Card(
    elevation: 2.0,
    // color: const Color(0xFFF0EEF6), //Colors.grey.shade300,
    color: color,
    margin: const EdgeInsets.only(top: 10.0),
    shape: shape,
    child: child,
  );