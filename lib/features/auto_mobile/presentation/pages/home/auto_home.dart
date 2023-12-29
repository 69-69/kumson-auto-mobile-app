import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/home_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/parent_background.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'components/user_current_location.dart';

class AutoHome extends StatefulWidget {
  const AutoHome({super.key});

  @override
  State<AutoHome> createState() => _AutoHomeState();
}

class _AutoHomeState extends State<AutoHome>
    with SingleTickerProviderStateMixin {
  bool isManual = false;
  bool isPartNo = false;
  bool isVin = false;
  int _currentIndex = 0;
  List<Widget> _bottomScreens = [];
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

    _initializeBottomMenus();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _bottomScreens.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _initializeBottomMenus();
    super.didChangeDependencies();
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

  void _userLocation() {
    UserCurrentLocation(context, asyncLocation: (place) {
      // debugPrint('${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
      // return Text('${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
    })
        .getCurrentPosition();
  }

  void updateMenu(int index) => setState(() => _currentIndex = index);

// List of screens
  void _initializeBottomMenus() {
    _bottomScreens = [
      const Text('Shop for All Parts here!'),
      const Text('Shop for All Parts here!'),
      const Text('My Favorite Parts here!'),
      const Text('Chat with Company Rep here!'),
      const Text('Logged In user Profile Here!'),
    ];
    setState(() {});
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
      appBar: HomeAppBar(onPress: () {
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
          _currentIndex > 0
              ? _bottomScreens[_currentIndex]
              : _buildBody(customTheme, context),
          animationItems,
        ),
      ),
      bottomNavigationBar: buildFancyBottomNavigation(bottomNavLabels(3)),
    );
  }

  /*HomeTemplate _buildBody2() {
    return HomeTemplate(
      bottomNavigation: buildFancyBottomNavigation(bottomNavLabels(3)),
      bottomWidget: SizedBox(width: SizeConfig.screenWidth),
      // hideAppBar: _currentIndex == 0 ? true : false,
      // child: _bottomScreens[_currentIndex],
      *//* bottomWidget: Builder(
      builder: (context) {
        final userId = context.select(
          (AuthBloc bloc) => bloc.state.loggedInUser.role,
        );
        return Text(
          "Role: $userId",
          style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.white),
        );
      },
    ),*//*
    );
  }*/

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
        buildColoredBorder(
          false,
          context,
          padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 7.0),
          child: SizedBox(width: SizeConfig.screenWidth),
        ),
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

  FancyBottomNavigation buildFancyBottomNavigation(
      List<Map<String, dynamic>> barItems) {
    return FancyBottomNavigation(
      tabs: List.generate(
        barItems.length,
        (i) => TabData(
          title: barItems[i]["label"],
          iconData: barItems[i]["icon"],
          badges: barItems[i]['badge'],
        ),
      ),
      onTabChangedListener: updateMenu,
      /*(position){setState(() => _currentIndex = position);},*/
    );
  }

  bottomNavLabels(int chatBadge) {
    final List<Map<String, dynamic>> barItems = [
      {"label": "Home", "icon": Icons.home, 'badge': 0},
      {"label": "Shop", "icon": Icons.shop_2, 'badge': 0},
      {"label": "Favorite", "icon": Icons.favorite, 'badge': 2},
      {"label": "Chats", "icon": Icons.message, 'badge': chatBadge},
      {"label": "Profile", "icon": Icons.person, 'badge': 0},
    ];
    return barItems;
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
