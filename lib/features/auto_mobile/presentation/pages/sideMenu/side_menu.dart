import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _customDrawer(context);
  }

  Drawer _customDrawer(BuildContext context) => Drawer(
        // backgroundColor: const Color.fromRGBO(250, 249, 249, 0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const DrawerHeader(
                margin: EdgeInsets.zero,
                child: Text(
                  appName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                    height: 1.3,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    listTile('About'),
                    listTile('Contact'),
                    listTile('Feedback'),
                  ],
                ),
              ),
              const Divider(),
              Builder(builder: (context) {
                final userId = context.select(
                  (AuthBloc bloc) => bloc.state.user.id,
                );
                return userId.isNotEmpty ? listTile(
                  'Logout',
                  onPress: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    pageNavigator(context, routeName: autoHomeWithAuthRoute);
                  },
                ) : const SizedBox.shrink();
              }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );

  ListTile listTile(String title, {void Function()? onPress}) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onPress,
    );
  }
}
