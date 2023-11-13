// stores ExpansionPanel state information
class CustomAppBarModel {
  CustomAppBarModel({
    this.routeName,
    this.arguments,
    this.expandedHeight,
    this.imageUrl = "",
     this.title = "",
     this.subTitle ="",
     this.subMiniTitle = "",
     this.currentScreen = "",
  });

  String? routeName;
  Object? arguments;
  double? expandedHeight;
  String imageUrl;
  String title;
  String subTitle;
  String subMiniTitle;
  String currentScreen;
}