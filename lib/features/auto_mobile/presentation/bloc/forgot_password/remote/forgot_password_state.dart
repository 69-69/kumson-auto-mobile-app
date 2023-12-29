part of 'forgot_password_bloc.dart';

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.emailOrPhone = const EmailOrPhone.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final EmailOrPhone emailOrPhone;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  ForgotPasswordState copyWith({
    FormzSubmissionStatus? status,
    EmailOrPhone? emailOrPhone,
    Password? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, emailOrPhone, password, errorMessage];
}
