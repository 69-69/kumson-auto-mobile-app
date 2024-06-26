import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/auth_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/developer_info.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/remote/auth_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _customDrawer(context);
  }

  Drawer _customDrawer(BuildContext context) {
    final currentUser =
        context.select((AuthBloc bloc) => bloc.state.currentUser);

    return Drawer(
      // backgroundColor: const Color.fromRGBO(250, 249, 249, 0.4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 100,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: _userAvatar(context, username: currentUser.name),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (currentUser.isNotEmpty) ...{
                      listTile('Profile', icon: Icons.account_box_rounded),
                      listTile(
                        'Dashboard',
                        icon: Icons.dashboard,
                        onPress: ()=> pageNavigator(
                          context,
                          routeName: autoHomeRoute,
                        ),
                      ),
                    },
                    listTile('Service', icon: Icons.home_repair_service),
                    listTile('Contact', icon: Icons.contact_support),
                    listTile('Chat with REP.', icon: Icons.chat_outlined),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 0.5),
            if (currentUser.isNotEmpty) ...{
              listTile(
                'Logout',
                icon: Icons.logout,
                onPress: () =>
                    context.read<AuthBloc>().add(AuthLogoutRequested()),
              )
            } else ...{
              listTile(
                'LogIn',
                icon: Icons.account_box,
                onPress: () => buildAuthModal(context, 'login'),
              ),
              listTile(
                'SignUp',
                icon: Icons.app_registration,
                onPress: () => buildAuthModal(context, 'signup'),
              ),
            },
            listTile('Feedback', icon: Icons.feedback),
            const Divider(height: 1, thickness: 0.5),
            listTile(
              const DeveloperInfo(
                fontSize: 12,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Theme _userAvatar(BuildContext context, {String username = ''}) {
    final tColor = Theme.of(context).colorScheme;
    bool notLoggedInUser = username == 'unknown' || username == '';

    final avatar = notLoggedInUser
        ? Image.asset(appLogo)
        : const Icon(Icons.person, color: Colors.white70);

    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Chip(
        side: BorderSide.none,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        avatar: CircleAvatar(
          backgroundColor: tColor.primary,
          child: avatar,
        ),
        label: Text(
          (notLoggedInUser ? appName : username).capitalizeEach(),
          style: TextStyle(
            height: 1,
            fontSize: 20.0,
            color: tColor.onBackground,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        labelPadding: const EdgeInsets.only(left: 5.0),
        padding: EdgeInsets.zero,
      ),
    );
  }

  ListTile listTile(dynamic title, {IconData? icon, void Function()? onPress}) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      iconColor: Colors.grey,
      dense: true,
      title: title is String
          ? Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : title,
      onTap: onPress,
    );
  }
}

class SideMenuModel {
  SideMenuModel({
    required this.id,
    required this.label,
    required this.route,
  });

  int id;
  String label;
  String route;
}
