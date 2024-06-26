import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_snackbar.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/auth_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/home_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/otp/remote/otp_bloc.dart';
import 'package:automasters/features/auto_mobile/data/models/signup.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/user_current_location.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/recent_search_button.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/welcome_search_input.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/welcome_header.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/welcome_manual_search.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/remote/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/parent_background.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key, this.activeSignup});

  final SignupModel? activeSignup;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isScrollUp = false;
  String phoneNumber = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ScaffoldState? get _scaffold => scaffoldKey.currentState;

  @override
  void initState() {
    onLaunchShowDialog();
    _userLocation();

    super.initState();
  }

  /*@override
  void didChangeDependencies() {
    _userLocation();

    super.didChangeDependencies();
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  bool get isActiveSignup {
    final data = widget.activeSignup ?? SignupModel.empty;
    setState(() => phoneNumber = data.phoneNumber);
    return data.isNotEmpty;
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // _authCard(context);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: _appBar(scaffoldKey),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ParentBackground(
        child: _buildBody(scaffoldKey),
      ),
      drawer: const SideMenu(),
    );
  }

  _appBar(GlobalKey<ScaffoldState> scaffoldKey) {
    if (isScrollUp) {
      return HomeAppBar(
        onPress: () {
          if (scaffoldKey.currentState!.isDrawerOpen) {
            //close drawer, if drawer is open
            scaffoldKey.currentState!.closeDrawer();
          } else {
            //open drawer, if drawer is closed
            scaffoldKey.currentState!.openDrawer();
          }
        },
      );
    }
  }

  _buildBody(GlobalKey<ScaffoldState> scaffoldKey) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WelcomeHeader(scaffoldKey: scaffoldKey),
        const Text(
          appSubTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
            height: 0.1,
          ),
        ),
        const Divider(thickness: 0.3),
        SizedBox(
          height: getProportionateScreenHeight(15.0),
        ),
        _WelcomeBody(scaffoldKey: scaffoldKey),
      ],
    );
  }

  _authCard(BuildContext context) {

    final currentUser = context.select(
          (AuthBloc bloc) => bloc.state.currentUser,
    );

    // Future.delayed(Duration.zero,(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(currentUser.isEmpty) {
        final tColor = Theme.of(context).colorScheme;
        customSnackBar(
          context,
          content: buildAuthButton(context, tColor),
          timeout: const Duration(seconds: 10),
          bgColor: tColor.onPrimary,
        );
      }
    });
  }

  Column buildAuthButton(BuildContext context, ColorScheme tColor) {
    return Column(
      children: [
        /// Or Section
        orSeparator(
          lineColor: tColor.primary,
          textColor: tColor.primary,
        ),

        /// Don't have an account
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildOutlinedButton(context, 'SignUp'),
            buildOutlinedButton(context, 'LogIn'),
          ],
        )
      ],
    );
  }

  OutlinedButton buildOutlinedButton(BuildContext context, String label) {
    return buildOutlinedBtn(
      context,
      label: label,
      onPress: () => buildAuthModal(context, label),
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
      await AppLocalService().saveProductStatus(opt);
    }
  }

  void onButtonPress() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isActiveSignup) {
        context.read<ResendOTPBloc>().add(OTPResendSubmitted(phoneNumber));
        buildAuthModal(context, 'Sign Up');
      }
    });
  }
}

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody({required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    // final currentUser = context.select((AuthBloc bloc) => bloc.state.currentUser);

    // final routeName = currentUser.isNotEmpty ? autoHomeRoute : appRootRoute;

    final tColor = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "SEARCH\nFAVORITE CAR PARTS",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            fontSize: 25.0,
            height: 1.5,
          ),
        ),
        /// Or Section
        orSeparator(
          label: Icons.search,
          iconSize: 7,
          lineColor: tColor.secondaryContainer,
          bgColor: Colors.white,
          textColor: tColor.primary,
        ),
        SizedBox(
          height: getProportionateScreenHeight(12.0),
        ),
        const RecentSearch(),
        const SizedBox(height: 10.0),
        const WelcomeSearchInput(),
        const SizedBox(height: 10.0),
        const WelcomeManualSearch(),
        Text(
          'Categories',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const _WelcomeProducts(),
        const SizedBox(height: 10.0),
        /*const Divider(thickness: 0.3, height: 0.2),
        buildBtn(context, routeName, 'SHOP CAR PARTS'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: orSeparator(
            text: 'Or Search By',
            lineColor: tColor.primary,
            textColor: tColor.primary,
          ),
        ),
        buildBtn(context, routeName, 'MAKE & MODEL'),
        const SizedBox(height: 10.0),
        buildBtn(context, routeName, 'PART NO.'),
        const SizedBox(height: 10.0),
        buildBtn(context, routeName, 'VIN'),*/
      ],
    );
  }

  buildBtn(
    BuildContext context,
    String routeName,
    String title,
  ) {
    return title.toLowerCase() == 'shop car parts'
        ? buildElevatedBtn(
            label: title,
            context,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            onPress: () => pageNavigator(context, routeName: routeName),
          )
        : buildOutlinedBtn(
            label: '[ $title ]',
            context,
            borderColor: Colors.transparent,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            onPress: () => pageNavigator(context, routeName: routeName),
          );
  }
}

class _WelcomeProducts extends StatelessWidget {
  const _WelcomeProducts();

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  buildBody(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      padding: EdgeInsets.zero,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(2, (index) {
        return buildCard(context, index);
      }),
    );
  }

  buildCard(BuildContext context, int index) {
    final img = index == 1 ? gearBox : carBulb;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(-2, -1),
            blurRadius: 8,
          )
        ],
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
        /*gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.white, Colors.grey.shade200],
        ),*/
      ),
      // color: Theme.of(context).colorScheme.surface,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(310 / 180 * pi),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Image.asset(img, fit: BoxFit.cover),
            ),
            const SizedBox(height: 5,),
            FittedBox(
              child: GestureDetector(
                child: Text(
                  index == 0 ? 'Gear Box' : 'Light Bulb',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
