import 'package:flutter/material.dart';

Widget customLine(String text, BuildContext context,
    {bool isUnderline = true,
    bool isActive = true,
    Color? color,
    double fontSize = 18.0}) {
  ColorScheme tColor = Theme.of(context).colorScheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SelectionArea(
        child: Text(
          text,
          style: TextStyle(
            color: isActive
                ? (color ?? tColor.onBackground) /*const Color(0xFF333333)*/
                : tColor.onSurface.withOpacity(.5),
            fontSize: isActive ? fontSize : (fontSize - 2),
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      isActive && isUnderline
          ? Container(
              margin: const EdgeInsets.only(top: 2.0),
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          : const SizedBox.shrink()
    ],
  );
}
