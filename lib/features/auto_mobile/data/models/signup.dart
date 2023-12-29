import 'package:equatable/equatable.dart';

class SignupModel extends Equatable {
  final String email;
  final String password;
  final String phoneNumber;

  const SignupModel({
    this.email = "",
    this.password = "",
    this.phoneNumber = "",
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }

  /// Update Signup Object/Model property[copy]
  SignupModel copy({
    String? email,
    String? password,
    String? phoneNumber,
  }) =>
      SignupModel(
        email: email ?? "",
        password: password ?? "",
        phoneNumber: phoneNumber ?? "",
      );

  /// Empty signup-data which represents an unknown.
  static const empty = SignupModel(email: '');

  /// Convenience getter to determine whether the current signup-data is empty.
  bool get isEmpty => this == SignupModel.empty;

  /// Convenience getter to determine whether the current signup-data is not empty.
  bool get isNotEmpty => this != SignupModel.empty;

  @override
  List<Object?> get props => [email, password, phoneNumber];
}
