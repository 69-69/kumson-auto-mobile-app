import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/data/models/signup.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/otp/remote/otp_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/auth_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/home_template.dart';

class AutoHomeWithAuth extends StatefulWidget {
  const AutoHomeWithAuth({super.key, this.activeSignup});

  final SignupModel? activeSignup;

  @override
  State<AutoHomeWithAuth> createState() => _AutoHomeWithAuthState();
}

class _AutoHomeWithAuthState extends State<AutoHomeWithAuth> {
  bool isInProgress = false;
  String phoneNumber = '';

  @override
  void initState() {
    onButtonPress(); // simulate button press
    super.initState();
  }

  bool get isActiveSignup {
    final data = widget.activeSignup ?? SignupModel.empty;
    setState(() => phoneNumber = data.phoneNumber);
    return data.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return HomeTemplate(bottomWidget: buildAuthButton(context));
  }

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
        )
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

  void onButtonPress() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isActiveSignup) {
        context.read<ResendOTPBloc>().add(OTPResendSubmitted(phoneNumber));
        buildAuthModal(context, 'Sign Up');
      }
    });
  }
}
