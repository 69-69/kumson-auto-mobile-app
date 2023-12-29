import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/recent_search_button.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/search_input.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/welcome_header.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/welcome/welcome_manual_search.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/remote/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_snackbar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/parent_background.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      /*appBar: HomeAppBar(
        onPress: () {
          if (scaffoldKey.currentState!.isDrawerOpen) {
            //close drawer, if drawer is open
            scaffoldKey.currentState!.closeDrawer();
          } else {
            //open drawer, if drawer is closed
            scaffoldKey.currentState!.openDrawer();
          }
        },
      ),*/
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ParentBackground(
        child: _buildBody(context, scaffoldKey),
      ),
      drawer: const SideMenu(),
    );
  }

  Column _buildBody(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) {
    final currentUser =
        context.select((AuthBloc bloc) => bloc.state.loggedInUser);
    final routeName =
        currentUser.isNotEmpty ? autoHomeRoute : autoHomeWithAuthRoute;

    final tColor = Theme.of(context).colorScheme;

    if (currentUser.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        customSnackBar(
          context,
          content: 'Welcome, You\'re successfully logged in!',
          timeout: const Duration(seconds: 4),
          bgColor: tColor.primary,
        );
      });
      // buildChip('Logged In Successful');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WelcomeHeader(scaffoldKey: scaffoldKey),
        const Text(
          appSubTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
            height: 0.1,
          ),
        ),
        const Divider(thickness: 0.3),
        Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(30.0),
            ),
            const RecentSearch(),
            const SizedBox(height: 10.0),
            const SearchInput(),
            const WelcomeManualSearch(),
            const _WelcomeBody(),
            const SizedBox(height: 10.0),
            const Text(
              "SEARCH\nFAVORITE CAR\nPARTS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(thickness: 0.3, height: 0.2),
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
            buildBtn(context, routeName, 'VIN'),
          ],
        ),
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

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody();

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
        return buildCard(context);
      }),
    );
  }

  Card buildCard(BuildContext context) {
    return Card(
      elevation: 7,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(appHomeBg, fit: BoxFit.cover),
      ),
    );
  }
}
