import 'package:automasters/features/auto_mobile/presentation/pages/home/components/user_current_location.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/parent_background.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';

import 'home_app_bar.dart';

class HomeTemplate extends StatefulWidget {
  const HomeTemplate({
    super.key,
    this.child,
    this.bottomWidget,
    this.bottomNavigation,
    this.hideAppBar = false,
  });

  final bool hideAppBar;
  final Widget? child;
  final Widget? bottomWidget;
  final Widget? bottomNavigation;

  @override
  State<HomeTemplate> createState() => _HomeTemplateState();
}

class _HomeTemplateState extends State<HomeTemplate>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  @override
  void initState() {
    createAnimation();

    onLaunchShowDialog();
    _userLocation();
    super.initState();
  }

  void createAnimation() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    for (int i = 0; i < 10; i++) {
      animationItems.add(
        AnimationItem(
          id: "slide-${i + 1}",
          entry: 30 * (i + 1),
          entryDuration: 250,
          visible: false,
        ),
      );
    }
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
      ..addListener(() {
        setState(() {
          animationItems = updateVisibleState(
            animationItems,
            animation.value,
          );
        });
      });
    animationController.forward();
  }

  /// display welcome dialog on screen launch with 2-seconds delay
  void onLaunchShowDialog() {
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(seconds: 2), () {
          AppLocalService().getProductStatus().isEmpty
              ? displayDialog()
              : false;
        });
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _userLocation() {
    UserCurrentLocation(context, asyncLocation: (place) {
      // debugPrint('${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
      // return Text('${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
    })
        .getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final customTheme = Theme.of(context);

    // Lets restart the app so icons can load
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      // const Color(0xFFF6EEF2),
      appBar: widget.hideAppBar
          ? null
          : HomeAppBar(onPress: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                //close drawer, if drawer is open
                scaffoldKey.currentState!.closeDrawer();
              } else {
                //open drawer, if drawer is closed
                scaffoldKey.currentState!.openDrawer();
              }
            }),
      // your drawer
      drawer: const SideMenu(),
      body: ParentBackground(
        child: buildAnimatedSwitcher(
          widget.child ?? _buildBody(customTheme, context),
          animationItems,
        ),
      ),
      bottomNavigationBar: widget.bottomNavigation,
    );
  }

  Column _buildBody(ThemeData customTheme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _subDesc(),
        buildColoredBorder(
          true,
          context,
          child: buildTopBg(customTheme),
        ),
        CollapsePanel(),
        widget.bottomWidget != null
            ? buildColoredBorder(
                false,
                context,
                padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 7.0),
                child: widget.bottomWidget,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Padding _subDesc() {
    final tColor = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 40.0),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: 'Car Parts\n& Accessories\n',
          style: TextStyle(
            height: 1.2,
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
            color: tColor.primary,
          ),
          children: [
            TextSpan(
              text:
                  'Search Genuine Parts & Accessories\nfor your vehicle. Search by...',
              style: TextStyle(
                height: 1.5,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                color: tColor.onBackground.withOpacity(0.8),
              ),
              children: [
                TextSpan(
                  text: 'VIN, PART-NO., MAKE or MODEL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tColor.onBackground.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildTopBg(ThemeData customTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOptionalBtn(customTheme, onPress: () => displayDialog()),
        textOverflow(
          width: 0.7,
          textAlign: TextAlign.center,
          text: "Search Car Parts by:",
          textStyle: customTheme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        _buildOptionalBtn(customTheme,
            icon: Icons.restore, onPress: () => displaySearchHistory())
      ],
    );
  }

  _buildOptionalBtn(ThemeData customTheme,
          {IconData? icon, void Function()? onPress}) =>
      buildQuestionButton(context,
          icon: icon,
          bgColor: Colors.white.withOpacity(0.6),
          color: customTheme.colorScheme.primary,
          onPress: onPress);

  buildColoredBorder(bool isTop, BuildContext context,
      {Widget? child, EdgeInsets? padding}) {
    Radius rdZero = Radius.zero;
    Radius rd = const Radius.circular(22);

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.primary,
      //.withOpacity(0.6),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: isTop ? rd : rdZero,
          topLeft: isTop ? rd : rdZero,
          bottomLeft: isTop ? rdZero : rd,
          bottomRight: isTop ? rdZero : rd,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(7.0),
        child: child,
      ),
    );

    /*return Container(
      width: SizeConfig.screenWidth!,
      margin: EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        borderRadius: BorderRadius.only(
          topRight: isTop ? rd : rdZero,
          topLeft: isTop ? rd : rdZero,
          bottomLeft: isTop ? rdZero : rd,
          bottomRight: isTop ? rdZero : rd,
        ),
      ),
      child: child,
    );*/
  }

  displayDialog() async {
    KeyboardUtil.hide;

    final opt = await showConfirmationDialog(
      context,
      title: "Welcome",
      isDismissible: false,
      positiveResponse: "New",
      negativeResponse: "Used",
      const Text("Search for New or Used Car Parts?"),
    );
    if (context.mounted && opt != "cancel") {
      await AppLocalService().saveProductStatus(opt);
    }
  }

  displaySearchHistory() {
    KeyboardUtil.hide;

    return buildModal(
      context,
      const SearchHistory(),
      bgColor: Colors.transparent,
      barColor: const Color.fromRGBO(250, 249, 249, 0.3),
    );
  }
}
