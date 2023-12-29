import 'package:flutter/material.dart';

customSnackBar(
  BuildContext context, {
  required dynamic content,
  bool? showCloseIcon,
  Duration? timeout,
  Color? bgColor,
}) {
  final snackBar = SnackBar(
    backgroundColor: bgColor,
    showCloseIcon: showCloseIcon,
    behavior: SnackBarBehavior.fixed,
    dismissDirection: DismissDirection.up,
    duration: timeout ?? const Duration(seconds: 3),
    content: content is Text
        ? content
        : Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
