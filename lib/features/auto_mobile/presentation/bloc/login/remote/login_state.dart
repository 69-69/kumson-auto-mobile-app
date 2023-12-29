part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
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

  LoginState copyWith({
    FormzSubmissionStatus? status,
    EmailOrPhone? emailOrPhone,
    Password? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginState(
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
