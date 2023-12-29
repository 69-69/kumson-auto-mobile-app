part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

final class SignupEmailChanged extends SignupEvent {
  const SignupEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class SignupFirstNameChanged extends SignupEvent {
  const SignupFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}


final class SignupLastNameChanged extends SignupEvent {
  const SignupLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class SignupPhoneChanged extends SignupEvent {
  const SignupPhoneChanged(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

final class SignupUserRoleChanged extends SignupEvent {
  const SignupUserRoleChanged(this.userRole);

  final String userRole;

  @override
  List<Object> get props => [userRole];
}

final class SignupPasswordChanged extends SignupEvent {
  const SignupPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignupConfirmedPasswordChanged extends SignupEvent {
  const SignupConfirmedPasswordChanged(this.confirmedPassword);

  final String confirmedPassword;

  @override
  List<Object> get props => [confirmedPassword];
}

final class SignupFormSubmitted extends SignupEvent {
  const SignupFormSubmitted();
}

