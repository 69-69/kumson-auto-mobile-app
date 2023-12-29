import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/otp/otp_input_field.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/otp/resend_otp.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';

class OTPForm extends StatefulWidget {
  const OTPForm({
    super.key,
    this.phoneNumber,
  });

  final String? phoneNumber;

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  bool resendOTP = false;
  bool isExpired = false;
  bool isInCorrect = false;
  bool hideErrorMsg = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildOTPVerification(context);
    /*BlocListener<OTPBloc, OTPState>(
      listener: (_, state) {
        if (state.status.isFailure) {
          setState(() {
            hideErrorMsg = false;
          });
        }
      },
      child: */
  }

  _buildOTPVerification(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitleHeader(
          context,
          "Account Verification",
          "We sent short code to ${widget.phoneNumber?.replaceAll(truncateStrRegExp, '**')}",
        ),
        const Divider(thickness: 1),
        if ((isInCorrect || isExpired) && !hideErrorMsg) ...{
          buildChip(
            isExpired
                ? 'Your code expired...Resend again!'
                : 'The code you entered is incorrect...Try again!',
            onDelete: () => setState(() => hideErrorMsg = !hideErrorMsg),
          ),
          const Divider(thickness: 0.3, height: 0.2),
        },

        OTPInputField(
          resendOTP: resendOTP,
          phoneNumber: widget.phoneNumber ?? '',
          onChanged: (inValid, hideError) {
            setState(() {
              isInCorrect = inValid;
              hideErrorMsg = hideError;
            });
          },
        ),
        buildTimer(context, '$resendOTP'),
        SizedBox(height: getProportionateScreenHeight(10)),
        ResendOTP(
          isExpired: isExpired,
          phoneNumber: widget.phoneNumber ?? '',
          onChanged: (isExpire, resendOtp) {
            setState(() {
              resendOTP = true;
              isExpired = false;
            });
          },
        ),

        /// Or Section
        orSeparator(
          lineColor: tColor.primary,
          textColor: tColor.primary,
        ),
        buildOutlinedBtn(
          context,
          label: "Change Mobile number",
          key: const Key('edit_phone_no'),
          borderColor: Colors.transparent,
          onPress: () => pageNavigator(
            context,
            routeName: otpPhoneNumberFrom,
            arguments: 'Enter New Mobile number',
          ),
        ),
      ],
    );
  }

  Row buildTimer(BuildContext context, String resetKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't get Code? Resend OTP in ",
          style: TextStyle(fontSize: 12),
        ),
        _buildTweenAnimationBuilder(resetKey: resetKey),
      ],
    );
  }

  TweenAnimationBuilder<double> _buildTweenAnimationBuilder({
    String? resetKey,
  }) {
    resetKey = resetKey;
    return TweenAnimationBuilder(
      key: ValueKey('_timer_key_$resetKey'),
      tween: Tween(begin: 99.0, end: 0.0),
      duration: const Duration(seconds: 99),
      onEnd: () {
        setState(() {
          resetKey = null;
          isExpired = true;
          hideErrorMsg = false;
        });
      },
      builder: (_, value, __) {
        // Strip off first two number from double (ex: 26.6453)
        int expiryCountDown = int.parse('$value'.split('.')[0]);

        return Text(
          "00:$expiryCountDown",
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

/*
  otpInputField(BuildContext context, ColorScheme tColor) {
    final activeOTP = context.select((AuthBloc bloc) => bloc.state.activeOTP);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: BlocBuilder<VerifyOTPBloc, OTPState>(
        builder: (context, state) => OtpTextField(
          borderWidth: 4,
          numberOfFields: 5,
          focusedBorderColor: tColor.primary,
          //set to true to show as box or false to show as dash
          showFieldAsBox: true,
          clearText: resendOTP,
          onCodeChanged: (String userOTP) {
            //handle validation or checks here
          },
          //runs when every textField is filled
          onSubmit: (String userOTP) {
            if (userOTP == activeOTP.otp) {
              context
                  .read<VerifyOTPBloc>()
                  .add(VerifyOTPSubmitted(widget.phoneNumber!));
              return;
            }

            setState(() {
              isInCorrect = true;
              hideErrorMsg = false;
            });
            // Verify Signup OTP
          }, // end onSubmit
        ),
      ),
    );
  }

  _buildResendOTP(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! * 0.8,
      child: BlocBuilder<ResendOTPBloc, OTPState>(
        builder: (context, state) {
          return state.status.isInProgress
              ? showCircularProgress(width: 15, height: 15)
              : buildElevatedBtn(
                  context,
                  label: "Resend OTP",
                  key: const Key('resend_otp_code'),
                  borderColor: Colors.transparent,
                  onPress: isExpired
                      ? () {
                          setState(() {
                            resendOTP = !resendOTP;
                            isExpired = !isExpired;
                          });
                          // Resend OTP via SMS
                          context
                              .read<ResendOTPBloc>()
                              .add(OTPResendSubmitted(widget.phoneNumber!));
                        }
                      : null,
                );
        },
      ),
    );
  }
*/
