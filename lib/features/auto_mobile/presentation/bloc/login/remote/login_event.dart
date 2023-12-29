part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEmailOrPhoneChanged extends LoginEvent {
  const LoginEmailOrPhoneChanged(this.emailOrPhone);

  final String emailOrPhone;

  @override
  List<Object> get props => [emailOrPhone];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginFormSubmitted extends LoginEvent {
  const LoginFormSubmitted();
}

