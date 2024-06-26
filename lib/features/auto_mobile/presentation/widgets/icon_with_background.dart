import 'package:flutter/material.dart';

class IconWithBackground extends StatelessWidget {
  const IconWithBackground({
    super.key,
    this.size,
    this.onTap,
    this.label,
    this.color,
    this.border,
    this.inPadding,
    this.exPadding,
    this.iconColor,
    this.onLongPress,
    this.borderRadius,
    this.gradientColor,
    required this.iconData,
  });

  final Widget? label;
  final double? size;
  final Color? color;
  final dynamic iconData;
  final Color? iconColor;
  final BoxBorder? border;
  final dynamic borderRadius;
  final Gradient? gradientColor;
  /// inPadding: internal padding, exPadding: external padding [inPadding], [exPadding]
  final double? inPadding, exPadding;
  final void Function()? onTap, onLongPress;

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = gradientColor != null
        ? BoxDecoration(gradient: gradientColor)
        : BoxDecoration(
            border: border,
            color: color ?? Theme.of(context).colorScheme.primary.withOpacity(0.1),
          );

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        // splashColor: AppColors.kPrimaryColor.withOpacity(0.1),
        // borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(exPadding ?? inPadding ?? 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                  child: Container(
                    decoration: boxDecoration,
                    padding: EdgeInsets.all(inPadding ?? 8.0),
                    child: Icon(
                      iconData,
                      color: iconColor ?? Theme.of(context).colorScheme.primary,
                      size: size,
                    ),
                  ),
                ),
                label ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
/* Material(
      borderOnForeground: true,
      borderRadius:
          radius ?? const BorderRadius.all(Radius.circular(8.0)),
      color: color ?? AppColors.kPrimaryColor.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: EdgeInsets.all(padding ?? 8.0),
          /* Check if file is image or icon */
          child: iconData is IconData
              ? Icon(
                  iconData,
                  color: iconColor ?? AppColors.kPrimaryColor,
                  size: size,
                )
              : SvgPicture.asset(
                  iconData,
                  color: iconColor ?? AppColors.kPrimaryColor,
                  height: size,
                ),
        ),
      ),
    ),*/
}

class DismissibleBackground extends StatelessWidget {
  final dynamic icon;
  final bool isSpace;
  final BorderRadiusGeometry? borderRadius;

  const DismissibleBackground({
    super.key,
    this.icon,
    this.isSpace = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (isSpace) const Spacer(),
          IconWithBackground(
            iconData: icon ?? Icons.delete,
            size: 15,
            inPadding: 2,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
