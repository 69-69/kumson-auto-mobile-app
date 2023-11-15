import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';

textOverflow({
  required String text,
  int? maxLines,
  double width = 0.5,
  TextStyle? textStyle,
  TextAlign? textAlign,
  TextOverflow? overflow,
}) {
  return SizedBox(
    width: SizeConfig.screenWidth! * width,
    child: Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: textStyle?.copyWith(
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
    ),
  );
}
