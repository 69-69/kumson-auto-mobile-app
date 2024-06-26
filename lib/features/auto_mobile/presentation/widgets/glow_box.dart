import 'package:flutter/material.dart';

/// Create glow/shadow around Widgets [GlowBox]
class GlowBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;
  final Border? border;
  final dynamic boxShadow;

  const GlowBox({
    super.key,
    this.width,
    this.color,
    this.border,
    this.boxShadow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.zero,
      width: width,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(50),
        color: color ?? const Color(0xFFFFECDF),
        boxShadow: boxShadow ??
            [
              const BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
              )
            ],
      ),
      child: child,
    );
  }
}
