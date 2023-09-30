import 'package:flutter/material.dart';
Widget customLine(String text, bool isActive, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          color:
          isActive ? const Color(0xFF333333) : Colors.black.withOpacity(.5),
          fontSize: isActive ? 18.0 : 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      isActive
          ? Container(
        margin: const EdgeInsets.only(top: 5.0),
        height: 4.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
      )
          : const SizedBox.shrink()
    ],
  );
}
