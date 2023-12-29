part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ForgotEmailOrPhoneChanged extends ForgotPasswordEvent {
  const ForgotEmailOrPhoneChanged(this.emailOrPhone);

  final String emailOrPhone;

  @override
  List<Object> get props => [emailOrPhone];
}

final class LoginPasswordChanged extends ForgotPasswordEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginFormSubmitted extends ForgotPasswordEvent {
  const LoginFormSubmitted();
}

