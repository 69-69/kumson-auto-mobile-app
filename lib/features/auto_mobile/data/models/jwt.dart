import 'package:automasters/features/auto_mobile/domain/entities/jwt.dart';

class JWTModel extends JWTEntity {
  const JWTModel({
    super.accessToken,
    super.expiresIn,
    super.refreshExpiresIn,
    super.refreshToken,

    // required this.images
  });

  JWTModel copyWith({
    String? accessToken,
    String? expiresIn,
    String? refreshExpiresIn,
    String? refreshToken,
  }) {
    return JWTModel(
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory JWTModel.fromJson(Map<String, dynamic> map) {
    return JWTModel(
      accessToken: map['accessToken'],
      expiresIn: map['accessExpiration'],
      refreshExpiresIn: map['refreshExpiresIn'],
      refreshToken: map['refreshToken'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory JWTModel.fromEntity(JWTEntity entity) => JWTModel(
    accessToken: entity.accessToken,
    expiresIn: entity.expiresIn,
    refreshExpiresIn: entity.refreshExpiresIn,
    refreshToken: entity.refreshToken,
  );

  static List<JWTModel> fromJsonList(List data) =>
      data.map((dynamic i) => JWTModel.fromJson(i as Map<String, dynamic>))
          .toList();

  ///custom comparing function to check if two models are equal
  bool isEqual(JWTModel model) => refreshToken == model.refreshToken;
}
