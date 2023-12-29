part of 'auth_bloc.dart';
/*
* [AuthEvent] instances will be the input to the AuthBloc and will be processed and used to emit new [AuthState] instances.

In this application, the [AuthenticationBloc] will be reacting to two different events:

[AuthStatusChanged]: notifies the bloc of a change to the user's [AuthStatus]
[AuthLogoutRequested]: notifies the bloc of a logout request
* */
sealed class AuthEvent {
  const AuthEvent();
}

final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.status);

  final AuthStatus status;
}

final class AuthLogoutRequested extends AuthEvent {}

/*final class VerifySignupRequested extends AuthEvent {
  VerifySignupRequested(this.phoneNumber);

  final String phoneNumber;
}

final class ResendOTPRequested extends AuthEvent {
  ResendOTPRequested(this.phoneNumber);

  final String phoneNumber;
}*/
