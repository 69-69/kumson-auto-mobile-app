import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/otp/remote/otp_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ResendOTP extends StatelessWidget {
  const ResendOTP({
    super.key,
    required this.isExpired,
    required this.phoneNumber,
    required this.onChanged,
  });

  final bool isExpired;
  final String phoneNumber;
  final Function(bool isInCorrect, bool hideErrorMsg) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResendOTPBloc>(
      create: (context) {
        return ResendOTPBloc(
          authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
        );
      },
      child: _buildResendOTP(context),
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
                          onChanged(false, true);
                          // Resend OTP via SMS
                          context
                              .read<ResendOTPBloc>()
                              .add(OTPResendSubmitted(phoneNumber));
                        }
                      : null,
                );
        },
      ),
    );
  }
}
