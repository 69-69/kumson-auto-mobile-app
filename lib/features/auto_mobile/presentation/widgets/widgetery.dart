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
          style: const TextStyle(
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: getProportionateScreenHeight(20)),
        Text(
          label2,
          maxLines: 1,
          style: const TextStyle(
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
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
