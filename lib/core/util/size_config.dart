import 'package:flutter/material.dart';
/*import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
PackageInfo packageInfo = await PackageInfo.fromPlatform();*/

/// Call SizeConfig.init on your starting Screen/Page
class SizeConfig {
  static Size? mediaSize;
  static bool? isMobile, isTablet, isDesktop;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;
  static MediaQueryData? _mediaQueryData;

  /// Call init to initialize the MediaQuery.of(context), to avoid errors [init]
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    mediaSize = _mediaQueryData!.size;

    screenWidth = mediaSize?.width;
    screenHeight = mediaSize?.height;
    isMobile = mediaSize!.width <= 600;
    // Large screens >=800 <1200 (tablet on landscape mode, mini laptop)
    isTablet = mediaSize!.width >= 800 && mediaSize!.width < 1200;
    // Large screens >=1200 (desktop, TV)
    isDesktop = mediaSize!.width >= 1200;
    orientation = _mediaQueryData!.orientation;
  }
}

// Get the proportionate Height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  if (inputHeight < 1) return 0;
  double? screenHeight = SizeConfig.screenHeight;
  // 812/844 is the Mobile Layout Height that designer use
  double? longSide = SizeConfig.mediaSize!.longestSide;/* 812/844 */
  double? shortSide = SizeConfig.mediaSize!.shortestSide;/* 375/390 */

  double? orientHeight =
      SizeConfig.orientation == Orientation.landscape ? shortSide : longSide;

  return (inputHeight / orientHeight) * screenHeight!;
}

// Get the proportionate Width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  if (inputWidth < 1) return 0;
  double? screenWidth = SizeConfig.screenWidth;
  // 375/390 is the Mobile Layout Width that designer use
  double? longSide = SizeConfig.mediaSize!.longestSide;/* 812/844 */
  double? shortSide = SizeConfig.mediaSize!.shortestSide;/* 375/390 */

  double? orientWidth =
      SizeConfig.orientation == Orientation.landscape ? longSide : shortSide;

  return (inputWidth / orientWidth) * screenWidth!;
}
