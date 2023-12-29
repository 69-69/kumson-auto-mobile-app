import 'package:automasters/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Notification Badges[BadgeCounter]
class BadgeCounter extends StatelessWidget {
  final String badge;
  final Color? bgColor, textColor, borderColor;
  final double? top, left, right, bottom;

  const BadgeCounter({
    super.key,
    this.bgColor,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.textColor,
    this.borderColor,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: bgColor ?? const Color(0xFFFF4848),
          shape: BoxShape.circle,
          border: Border.all(width: 1.5, color: borderColor ?? kErrorColor),
        ),
        constraints: const BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
        child: Center(
          child: Text(
            badge,
            style: TextStyle(
              fontSize: 8,
              height: 1,
              fontWeight: FontWeight.w600,
              color: textColor ?? kLightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
