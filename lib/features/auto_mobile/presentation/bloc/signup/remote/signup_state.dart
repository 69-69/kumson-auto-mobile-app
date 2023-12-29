part of 'signup_bloc.dart';

final class SignupState extends Equatable {
  const SignupState({
    this.email = const Email.pure(),
    this.userRole = const NameOrRole.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.firstName = const NameOrRole.pure(),
    this.lastName = const NameOrRole.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Email email;
  final NameOrRole userRole;
  final PhoneNumber phoneNumber;
  final NameOrRole firstName;
  final NameOrRole lastName;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  SignupState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    NameOrRole? userRole,
    PhoneNumber? phoneNumber,
    NameOrRole? firstName,
    NameOrRole? lastName,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      email: email ?? this.email,
      userRole: userRole ?? this.userRole,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        userRole,
        phoneNumber,
        firstName,
        lastName,
        password,
        confirmedPassword,
        isValid,
        errorMessage,
      ];
}
