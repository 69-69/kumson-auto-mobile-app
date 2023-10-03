import 'package:flutter/material.dart';
import '../models/animation_item.dart';
import '../utils/size_config.dart';
import '../widgets/collapse_panel.dart';
import '../widgets/scale_animation.dart';

class Home extends StatefulWidget {
  final String vin;

  const Home({super.key, this.vin = ""});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final customTheme = Theme.of(context);

    // Lets restart the app so icons can load
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent, // const Color(0xFFF6EEF2),
      appBar: buildAppBar(context),
      body: buildContainer(customTheme, context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: const SizedBox.shrink(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'Auto Masters',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 32.0,
          color: Color(0xFFD3AFAE),
          height: 1.3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Container(
          width: double.infinity,
          color: Colors.black12,
          padding: const EdgeInsets.all(1),
          child: Text(
            "Best Way to Buy Car Parts in Ghana",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container buildContainer(ThemeData customTheme, BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // all-car-parts.jpg
          image: AssetImage("assets/home-bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      height: SizeConfig.screenHeight!,
      width: SizeConfig.screenWidth!,
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(12.0),
            // color: const Color(0xFFC45245).withOpacity(0.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 8,
              )
            ],
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: SizeConfig.screenHeight! / 4,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ScaleAnimation(
              key: const ValueKey("home-main"),
              duration: getSlideDuration("slide-3", animationItems),
              direction: getItemVisibility("slide-3", animationItems),
              child: buildBody(customTheme, context),
            ),
          ),
        ),
      ),
    );
  }

  buildBody(ThemeData customTheme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildColoredBorder(
          context,
          const BorderRadius.only(
            topRight: Radius.circular(22),
            topLeft: Radius.circular(22),
          ),
          child: Text(
            "Search Car Parts by:",
            textAlign: TextAlign.center,
            style: customTheme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        CollapsePanel(vin: widget.vin),
        buildColoredBorder(
          context,
          const BorderRadius.only(
            bottomRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
          ),
        ),
      ],
    );
  }

  Container buildColoredBorder(
      BuildContext context, BorderRadiusGeometry borderRadius,
      {Widget? child}) {
    return Container(
      width: SizeConfig.screenWidth!,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
