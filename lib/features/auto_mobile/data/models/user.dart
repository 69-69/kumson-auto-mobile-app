
import 'package:automasters/features/auto_mobile/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.phone,
    super.role,
    super.ipAddress,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
    String? ipAddress,
  }) {
    return UserModel(
      id: this.id,
      email: this.email,
      firstName: this.firstName,
      lastName: this.lastName,
      phone: this.phone,
      role: this.role,
      ipAddress: this.ipAddress,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"].toString(),
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      role: map['role'],
      ipAddress: map['ipAddress'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phone: entity.phone,
        role: entity.role,
        ipAddress: entity.ipAddress,
      );

  static List<UserModel> fromJsonList(List data) => data
      .map((dynamic i) => UserModel.fromJson(i as Map<String, dynamic>))
      .toList();

  /// Empty user which represents an unauthenticated USER.
  static const empty = UserModel(id: '');

  get name => isEmpty ? '' : '$firstName $lastName';

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;
}
