import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.name,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserModel(
      id: this.id,
      email: this.email,
      name: this.name,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
      );

  static List<UserModel> fromJsonList(List data) =>
      data.map((dynamic i) => UserModel.fromJson(i as Map<String, dynamic>))
          .toList();

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;
}
