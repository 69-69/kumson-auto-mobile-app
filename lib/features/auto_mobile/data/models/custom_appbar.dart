// stores ExpansionPanel state information
class CustomAppBarModel {
  String? routeName;
  Object? arguments;
  double? expandedHeight;
  String imageUrl;
  String videoUrl;
  String title;
  String subTitle;
  String subMiniTitle;
  String currentScreen;

  CustomAppBarModel({
    this.routeName,
    this.arguments,
    this.expandedHeight,
    this.videoUrl = "",
    this.imageUrl = "",
    this.title = "",
    this.subTitle = "",
    this.subMiniTitle = "",
    this.currentScreen = "",
  });

  CustomAppBarModel copyWith({
    String? routeName,
    Object? arguments,
    double? expandedHeight,
    String? imageUrl,
    String? title,
    String? subTitle,
    String? subMiniTitle,
    String? currentScreen,
  }) {
    return CustomAppBarModel(
      routeName: routeName ?? this.routeName,
      arguments: arguments ?? this.arguments,
      expandedHeight: expandedHeight ?? this.expandedHeight,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      subMiniTitle: subMiniTitle ?? this.subMiniTitle,
      currentScreen: currentScreen ?? this.currentScreen,
    );
  }
}
