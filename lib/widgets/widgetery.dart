import 'package:automasters/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/animation_item.dart';
import 'fade_slide.dart';
import 'make_a_request_modal.dart';
import 'scale_animation.dart';
import '../utils/animation_transition.dart';


const ghCediSign = "GH";

Future<dynamic> buildModal(BuildContext context, Widget child, {Color? bgColor}) =>
    showModalBottomSheet(
        showDragHandle: true,
        isDismissible: true,
        isScrollControlled: true,
        // shape: roundedRectangleBorder(),
        backgroundColor: bgColor ?? Theme.of(context).colorScheme.onInverseSurface,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
        context: context,
        builder: (_) => child);

BorderRadius borderRadius() => const BorderRadius.vertical(
  top: Radius.circular(30),
);

RoundedRectangleBorder roundedRectangleBorder() {
  return RoundedRectangleBorder(
    borderRadius: borderRadius(),
  );
}

Container buildCurveContainer(EdgeInsets padding, {required Widget child}) {
  return Container(
    height: SizeConfig.screenHeight!,
    width: SizeConfig.screenWidth!,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: borderRadius(),
    ),
    padding: padding,
    child: child,
  );
}

Center buildMakeARequestButton(BuildContext context) {
  return Center(
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: ()=> buildModal(context, const MakeARequestModal(reqType: "Your Request")),
      child: const Text("Make a Request"),
    ),
  );
}

Widget customLine(String text, BuildContext context,
    {bool isUnderline = true, bool isActive = true, Color? color, double fontSize = 18.0}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          color: isActive
              ? (color ?? const Color(0xFF333333))
              : Colors.black.withOpacity(.3),
          fontSize: isActive ? fontSize : (fontSize-2),
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
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

PreferredSize buildPreferredSize(String text) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(0.0),
    child: Transform.translate(
      offset: const Offset(0, 50),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(text.toUpperCase()),
      ),
    ),
  );
}

AnimatedSwitcher buildAnimatedSwitcher(
    Widget child, List<AnimationItem> animationItems) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    child: ScaleAnimation(
      key: const ValueKey("img"),
      duration: getSlideDuration("slide-3", animationItems),
      direction: getItemVisibility("slide-3", animationItems),
      child: Align(
        alignment: Alignment.center,
        child: child,
      ),
    ),
  );
}

FadeSlide buildFadeSlide(List<AnimationItem> animationItems,
        {required Widget child}) =>
    FadeSlide(
      direction: getItemVisibility("slide-2", animationItems),
      duration: getSlideDuration("slide-2", animationItems),
      offsetY: 60.0,
      offsetX: 0.0,
      child: child,
    );

buildBackButton(BuildContext context, {Widget? route}) => GestureDetector(
      onTap: () => route == null
          ? Navigator.pop(context)
          : animateTransition(context, route),
      child: SizedBox(
        height: getProportionateScreenHeight(60.0),
        width: getProportionateScreenWidth(60.0),
        child: Icon(
          Icons.adaptive.arrow_back,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );

SliverAppBar buildSliverAppBars(
  BuildContext context,
  double expandedHeight,
  Widget backButton,
  Widget flexibleSpace, {
  bool primary = true,
  bool pinned = true,
  bool floating = false,
  bool centerTitle = true,
  PreferredSizeWidget? preferredSize,
}) {
  return SliverAppBar(
    primary: primary,
    // scrolledUnderElevation: 5.0,
    elevation: 0.0,
    pinned: pinned,
    floating: floating,
    centerTitle: centerTitle,
    expandedHeight: expandedHeight,
    leadingWidth: 80,
    leading: backButton,
    flexibleSpace: flexibleSpace,
    bottom: preferredSize,
    // backgroundColor: Theme.of(context).colorScheme.primary,
    /*shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),*/
  );
}

Text buildRichText(String item, String item2) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: [
        TextSpan(
          text: "${item.capitalizeEach()}\n",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
            color: Color(0xFFFFFFFF),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextSpan(
          text: item2.capitalizeEach(),
          style: const TextStyle(
            height: 1.7,
            fontSize: 13.0,
            color: Colors.white70,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

SizedBox buildProductAgeButton({void Function()? onPress, Color? color}) {
  return SizedBox(
    width: 25,
    height: 25,
    child: IconButton.outlined(
      iconSize: 10.0,
      onPressed: onPress,
      icon: Icon(Icons.question_mark_sharp,
          color: color ?? Colors.white),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide(color: color ?? Colors.white),
      ),
    ),
  );
}

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
