import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/models/animation_item.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/scale_animation.dart';

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
