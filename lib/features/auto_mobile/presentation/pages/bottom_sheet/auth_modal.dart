import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/login/login_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/signup/signup_form.dart';

Future<dynamic> buildAuthModal(BuildContext context, String authType) =>
    buildModal(context, AuthModal(authType: authType));

class AuthModal extends StatelessWidget {
  final String authType;

  const AuthModal({super.key, required this.authType});

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    bool isAuth = authType.toLowerCase().replaceAll(' ', '') == "login";
    double padSpace = isAuth ? getProportionateScreenWidth(20) : 0.0;

    return IntrinsicHeight(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: padSpace,
          right: padSpace,
          bottom: getProportionateScreenWidth(30),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: isAuth ? const LoginForm() : const SignupForm(),
        ),
      ),
    );
  }
}
