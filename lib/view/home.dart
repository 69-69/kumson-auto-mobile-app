import 'package:flutter/material.dart';
import '../models/animation_item.dart';
import '../widgets/horizontal_line.dart';
import '../utils/size_config.dart';
import '../widgets/show_confirmation_dialog.dart';
import '../widgets/widgetery.dart';
import '../widgets/auth_modal.dart';
import '../widgets/collapse_panel.dart';

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

    /// display welcome dialog on screen launch with 2-seconds delay
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Future.delayed(const Duration(seconds: 2),() => displayDialog());
    });

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
      // backgroundColor: Theme.of(context).colorScheme.primary,
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
          child: buildAnimatedSwitcher(
              buildBody(customTheme, context), animationItems),
        ),
      ),
    );
  }

  buildBody(ThemeData customTheme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildColoredBorder(
          true,
          context,
          child: Text(
            "Search Car Parts by:",
            textAlign: TextAlign.center,
            style: customTheme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        CollapsePanel(vin: widget.vin),
        buildColoredBorder(
          false,
          context,
          padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 7.0),
          child: buildAuthButton(context),
        ),
      ],
    );
  }

  Future<dynamic> buildAuthModal(BuildContext context, String authType) =>
      buildModal(context, AuthModal(authType: authType));

  Column buildAuthButton(BuildContext context) {
    return Column(
      children: [
        /// Or Section
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HorizontalLine(width: 4, color: Colors.white54),
            Text(
              'OR',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            HorizontalLine(width: 4, color: Colors.white54),
          ],
        ),

        /// Don't have an account
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
              ),
              onPressed: () => buildAuthModal(context, 'Log In'),
              child: const Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: Colors.white),
              ),
              onPressed: () => buildAuthModal(context, 'Sign Up'),
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container buildColoredBorder(bool isTop, BuildContext context,
      {Widget? child, EdgeInsets? padding}) {
    Radius rdZero = Radius.zero;
    Radius rd = const Radius.circular(22);

    return Container(
      width: SizeConfig.screenWidth!,
      margin: EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topRight: isTop ? rd : rdZero,
          topLeft: isTop ? rd : rdZero,
          bottomLeft: isTop ? rdZero : rd,
          bottomRight: isTop ? rdZero : rd,
        ),
      ),
      child: child,
    );
  }

  displayDialog() async {
    final opt = await showConfirmationDialog(
      context,
      title: "Welcome",
      isDismissible: false,
      positiveResponse: "New",
      negativeResponse: "Used",
      const Text("Shop for New or Used Car Parts?"),
    );
    if (context.mounted) {
      if (opt != "cancel") {}
    }
  }
}
