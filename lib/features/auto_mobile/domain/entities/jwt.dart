import 'package:equatable/equatable.dart';

class JWTEntity extends Equatable {
  final String? accessToken;
  final String? expiresIn;
  final String? refreshExpiresIn;
  final String? refreshToken;

  const JWTEntity({
    this.accessToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    accessToken,
    expiresIn,
    refreshExpiresIn,
    refreshToken,
  ];
}
