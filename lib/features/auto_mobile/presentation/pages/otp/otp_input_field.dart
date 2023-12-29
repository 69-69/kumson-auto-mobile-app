import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/remote/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/otp/remote/otp_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:formz/formz.dart';

class OTPInputField extends StatelessWidget {
  const OTPInputField({
    super.key,
    required this.resendOTP,
    required this.phoneNumber,
    required this.onChanged,
  });

  final bool resendOTP;
  final String phoneNumber;
  final Function(bool isInCorrect, bool hideErrorMsg) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerifyOTPBloc>(
      create: (context) {
        return VerifyOTPBloc(
          authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
        );
      },
      child: otpInputField(context),
    );
  }

  otpInputField(BuildContext context) {
    final activeOTP = context.select((AuthBloc bloc) => bloc.state.activeOTP);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: BlocBuilder<VerifyOTPBloc, OTPState>(
        builder: (context, state) => state.status.isInProgress
            ? showCircularProgress(width: 15, height: 15)
            : OtpTextField(
                borderWidth: 4,
                numberOfFields: 5,
                focusedBorderColor: Theme.of(context).colorScheme.primary,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                clearText: resendOTP,
                onCodeChanged: (String userOTP) {
                  //handle validation or checks here
                },
                //runs when every textField is filled
                onSubmit: (String userOTP) {
                  if (userOTP == activeOTP.otp) {
                    debugPrint('verify-> $userOTP==${activeOTP.otp}');
                    context
                        .read<VerifyOTPBloc>()
                        .add(VerifyOTPSubmitted(phoneNumber));
                    return;
                  }
                  onChanged(true, false);
                  // Verify Signup OTP
                }, // end onSubmit
              ),
      ),
    );
  }
}
