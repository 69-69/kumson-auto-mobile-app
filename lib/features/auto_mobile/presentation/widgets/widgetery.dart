import 'package:automasters/core/util/size_config.dart';
import 'package:flutter/material.dart';

BorderRadius borderRadius() => const BorderRadius.vertical(
      top: Radius.circular(30),
    );

RoundedRectangleBorder roundedRectangleBorder() {
  return RoundedRectangleBorder(
    borderRadius: borderRadius(),
  );
}

Container buildCurveContainer(BuildContext context, EdgeInsets padding,
    {required Widget child}) {
  return Container(
    height: SizeConfig.screenHeight!,
    width: SizeConfig.screenWidth!,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: borderRadius(),
    ),
    padding: padding,
    child: child,
  );
}


buildProductInfo(String label, String label2) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: getProportionateScreenHeight(20)),
        Text(
          label2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            /*color: Colors.black87,
              fontWeight: FontWeight.w500,*/
            fontSize: getProportionateScreenWidth(13),
          ),
          maxLines: 1,
        ),
      ],
    ),
  );
}

buildOptionalButton(BuildContext context,
    {void Function()? onPress, Color? bgColor, Color? color, IconData? icon}) {
  ColorScheme theme = Theme.of(context).colorScheme;

  return SizedBox(
    width: 30.0,
    height: 30.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? theme.onInverseSurface,
        padding: EdgeInsets.zero,
        shape: CircleBorder(
          side: BorderSide(color: color ?? theme.surfaceTint),
        ),
      ),
      onPressed: onPress,
      child: Icon(icon ?? Icons.question_mark_sharp, color: color ?? theme.surfaceTint, size: 20,),
    ),
  );
}

SizedBox buildContainerImage({required Widget child}) {
  return SizedBox(
    width: getProportionateScreenWidth(88),
    child: AspectRatio(
      aspectRatio: 0.88,
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
        /*decoration: const BoxDecoration(
            // color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset: Offset(4, 7),
                color: Colors.white54,
              )
            ],
          ),*/
        child: child,
      ),
    ),
  );
}
