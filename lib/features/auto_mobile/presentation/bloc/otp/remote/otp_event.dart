part of 'otp_bloc.dart';

sealed class OTPEvent extends Equatable {
  const OTPEvent();

  @override
  List<Object> get props => [];
}

/// Verify user's OTP [VerifyOTPSubmitted]
final class VerifyOTPSubmitted extends OTPEvent {
  const VerifyOTPSubmitted(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

/// Resend OTP, if Expired [OTPResendSubmitted]
final class OTPResendSubmitted extends OTPEvent {
  const OTPResendSubmitted(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

/// Change or Edit OTP Mobile number [OTPPhoneChanged]
final class OTPPhoneChanged extends OTPEvent {
  const OTPPhoneChanged(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

/// Submit the Changed OTP Mobile number [OTPPhoneFormSubmitted]
final class OTPPhoneFormSubmitted extends OTPEvent {
  const OTPPhoneFormSubmitted();
}
