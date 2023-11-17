import 'package:flutter/material.dart';

customSnackBar(BuildContext context, {required String msg}){

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.up,
    content: Text(
      msg,
      style: const TextStyle(fontSize: 20),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
