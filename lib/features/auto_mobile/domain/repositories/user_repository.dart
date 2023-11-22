import 'dart:async';

import 'package:automasters/features/auto_mobile/data/models/user.dart';
/// Responsible for the user domain and will expose
/// APIs to interact with the current user [UserRepository]

import 'package:uuid/uuid.dart';

class UserRepository {
  UserModel? _user;

  Future<UserModel?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
          () => _user = UserModel(id: const Uuid().v4()),
    );
  }
}
