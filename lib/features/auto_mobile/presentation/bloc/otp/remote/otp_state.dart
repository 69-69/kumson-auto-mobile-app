part of 'otp_bloc.dart';

final class OTPState extends Equatable {
  const OTPState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final PhoneNumber phoneNumber;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  OTPState copyWith({
    PhoneNumber? phoneNumber,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return OTPState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phoneNumber, errorMessage];
}
