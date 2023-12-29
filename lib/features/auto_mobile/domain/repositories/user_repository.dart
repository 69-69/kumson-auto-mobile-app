import 'dart:async';
import 'package:automasters/features/auto_mobile/data/models/user.dart';

abstract class UserRepository {

  Future<UserModel?> getUser();

  // Get SMS Config for send Text MSg or SMS
  Future<void> getSMSConfig();

  // Change OTP Mobile/Phone number
  Future<dynamic> update({
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParam,
  });
}
