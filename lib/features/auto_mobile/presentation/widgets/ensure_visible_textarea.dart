import 'package:flutter/material.dart';

Future<void> ensureVisibleOnTextArea({required GlobalKey textFieldKey}) async {
  final keyContext = textFieldKey.currentContext;
  if (keyContext != null) {
    await Future.delayed(const Duration(milliseconds: 500)).then(
          (value) => Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      ),
    );
    // Optional if doesn't work with the first
    // await Future.delayed(const Duration(milliseconds: 500)).then(
    //   (value) => Scrollable.ensureVisible(
    //     keyContext,
    //     duration: const Duration(milliseconds: 200),
    //     curve: Curves.decelerate,
    //   ),
    // );
  }
}