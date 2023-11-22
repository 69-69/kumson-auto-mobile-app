import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/sideMenu/side_menu.dart';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/animation_switcher.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/text_overflow.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/collapse_panel.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/auth_modal.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/data/models/animation_item.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/search_history.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/show_confirmation_dialog.dart';


class AutoHomeWithAuth extends StatefulWidget {
  const AutoHomeWithAuth({super.key});

  @override
  State<AutoHomeWithAuth> createState() => _AutoHomeWithAuthState();
}

class _AutoHomeWithAuthState extends State<AutoHomeWithAuth>
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
          SearchHistoryDB().getProductStatus().isEmpty
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final customTheme = Theme.of(context);

    final token =
        AppLocalDatabase().readData(key: accessTokenKey, defaultValue: "");
    if (token.isEmpty) {
      // print("form $token");
      AppLocalDatabase().writeData(
          key: accessTokenKey,
          data:
              "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZXZtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5OTY0MjU1MSwiZXhwIjoxNzMxMTc4NTUxfQ.3qYTmRe_fXy6Ef3DfOIuv2cl-T4LGw8OIPEEr5ses6o");
    }

    // 19unc1b14hy000003 - 12434452011
    // context.read<VehicleByVicBloc>().add(const GetModelsBy("12434452011"));
    /*void onRemoveArticle(BuildContext context, VehicleEntity v) {
      BlocProvider.of<LocalVehicleBloc>(context).add(RemoveSavedVehicle(v));
    }*/

    // Lets restart the app so icons can load
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      // const Color(0xFFF6EEF2),
      appBar: buildAppBar(context),
      // your drawer
      drawer: const SideMenu(),
      body: buildContainer(customTheme, context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      // iconTheme: IconThemeData(color: Colors.white,size: 30,),
      leading: _menuButton(),
      title: const Text(
        appName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 32.0,
          color: Color(0xFFD3AFAE),
          height: 1.3,
        ),
      ),
      bottom: _bottomCard(context),
    );
  }

  PreferredSize _bottomCard(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(5),
      child: Container(
        width: double.infinity,
        color: Colors.black26,
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
    );
  }

  IconButton _menuButton() {
    return IconButton(
      icon: const Icon(Icons.menu, size: 35,),
      color: Colors.white,
      onPressed: (){
        if(scaffoldKey.currentState!.isDrawerOpen){
          scaffoldKey.currentState!.closeDrawer();
          //close drawer, if drawer is open
        }else{
          scaffoldKey.currentState!.openDrawer();
          //open drawer, if drawer is closed
        }
      },
    );
  }

  Container buildContainer(ThemeData customTheme, BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // all-car-parts.jpg
          image: AssetImage(kHomeBg),
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
          child: buildTopBg(customTheme),
        ),
        CollapsePanel(),
        buildColoredBorder(
          false,
          context,
          padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 7.0),
          child: buildAuthButton(context),
        ),
      ],
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

  Future<dynamic> buildAuthModal(BuildContext context, String authType) =>
      buildModal(context, AuthModal(authType: authType));

  Column buildAuthButton(BuildContext context) {
    return Column(
      children: [
        /// Or Section
        orSeparator(),

        /// Don't have an account
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildOutlinedButton(context, 'Sign Up'),
            buildOutlinedButton(context, 'Log In'),
          ],
        ),
      ],
    );
  }

  OutlinedButton buildOutlinedButton(BuildContext context, String label) {
    return buildOutlinedBtn(
      context,
      label: label,
      color: Colors.white,
      onPress: () => buildAuthModal(context, label),
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
        color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
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
      await SearchHistoryDB().saveProductStatus(opt);
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
