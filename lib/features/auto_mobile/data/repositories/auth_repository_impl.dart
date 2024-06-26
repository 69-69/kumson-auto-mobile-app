import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/constants/endpoints.dart';
import 'package:automasters/features/auto_mobile/data/models/jwt.dart';
import 'package:automasters/features/auto_mobile/data/models/otp.dart';
import 'package:automasters/features/auto_mobile/data/models/signup.dart';
import 'package:automasters/features/auto_mobile/data/models/user.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/dio_util.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/auth_repository.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  continueSignup,
  otpCreated,
}

/// responsible for managing the authentication domain [AuthRepositoryImpl]
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = DioUtil.getInstance(interceptRequest: false);
  final _controller = StreamController<AuthStatus>();
  final AppLocalDatabase _cache = AppLocalDatabase();
  final AppLocalService _appLocalService = AppLocalService();

  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    yield _currentUser.isNotEmpty
        ? AuthStatus.authenticated
        : (currentSignup.isNotEmpty)
            ? AuthStatus.continueSignup
            : AuthStatus.unauthenticated;

    yield* _controller.stream;
  }

  bool isExpired(DateTime expiryDate) {
    String expiry = expiryDate.toString();
    // Return false if Empty
    if (expiry.isEmpty) return false;

    final now = DateTime.now();

    return DateTime.parse(expiry).isBefore(now);
  }

  DateTime addExtraTime(Duration extraTime) {
    final today = DateTime.now();
    final newDateTime = today.add(extraTime);
    return newDateTime;
  }

  /// Get Current-USER from CACHE: Return UserModel Or Empty [_currentUser]
  UserModel get _currentUser {
    final userCache = _cache.readCache(key: userCacheKey);
    if (userCache == null) return UserModel.empty;

    Map<String, dynamic> userMap = createNewMap(userCache);

    if (userMap.entries.isEmpty) return UserModel.empty;

    return UserModel.fromJson(userMap);
  }

  /// Get signup-ID from CACHE: Return Map Or Empty [currentSignup]
  SignupModel get currentSignup {
    final signupCache = _cache.readCache(key: signupIdCacheKey);
    if (signupCache == null) return SignupModel.empty;

    Map<String, dynamic> signupMap = createNewMap(signupCache);
    if (signupMap.entries.isEmpty) return SignupModel.empty;

    return SignupModel.fromJson(signupMap);
  }

  /// Get signup-OTP from CACHE: Return Map Or Empty [currentOTP]
  OTPModel get currentOTP {
    final otpCache = _cache.readCache(key: otpSignupCacheKey);
    if (otpCache == null) return OTPModel.empty;

    Map<String, dynamic> otpMap = createNewMap(otpCache);
    if (otpMap.entries.isEmpty) return OTPModel.empty;

    OTPModel otp = OTPModel.fromJson(otpMap);
    if (isExpired(otp.otpExpiry!)) {
      _cache.deleteCache(key: otpSignupCacheKey);
      return OTPModel.empty;
    }
    return otp;
  }

  Future<Response<dynamic>> _authPost(String apiUrl, dynamic data) async {
    _dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
    _dio.options.extra = EndPoints.forceDioHttpRefresh;

    final res = await _dio.post(apiUrl, data: data);
    return res;
  }

  Future<void> _signInFunction(String id, String password,
      {bool addStatus = false}) async {
    Response<dynamic> res = await _authPost(
        EndPoints.login, {"user_email": id, "user_password": password});

    if (res.statusCode == 200) {
      JWTModel token = JWTModel.fromJson(jsonDecode(res.toString()));
      // Save Access/Refresh Token in Cache
      _appLocalService.appToken(token);

      if (addStatus) {
        _controller.add(AuthStatus.authenticated);
      }
    } else {
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  /// Get temporal Access & Refresh Tokens
  /// for unknown-visitors of the APP [temporalToken]
  @override
  Future<void> temporalToken() async {
    final expiryDate = _cache.readCache(key: accessExpiresCacheKey);

    if (expiryDate == null || '$expiryDate'.isEmpty || isExpired(expiryDate)) {
      await _signInFunction(noReply, noReply);
    }
  }

  @override
  Future<void> logIn({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      // debugPrint(emailOrPhone);
      await _signInFunction(emailOrPhone, password, addStatus: true);
    } on DioException catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  @override
  Future<void> forgotPassword({required String emailOrPhone}) async {
    try {
      String otp = generateOTP();

      var res = await _dio
          .post("${EndPoints.forgotPassword}?id=$emailOrPhone&otp=$otp");
      if (res.statusCode == 200) {
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  // Change OTP Mobile/Phone number
  @override
  Future<void> changeOTPPhone({required String phoneNumber}) async {
    try {
      var res = await _dio.patch(EndPoints.user,
          data: {'email': currentSignup.email, 'phone': phoneNumber});

      if (res.statusCode == 200) {
        // Send OTP via SMS
        await sendOTP(phoneNumber: phoneNumber);
      } else {
        _controller.add(AuthStatus.unauthenticated);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String role,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      Response<dynamic> res = await _authPost(EndPoints.register, {
        'email': email,
        'role': role,
        'phone': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'ipAddress': '',
        'isMobileApp': true,
      });

      if (res.statusCode == 200) {
        // Save Active/Current Signup User Email for Reference in Cache
        _cache.writeCache(key: signupIdCacheKey, data: {
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password
        });

        // Send OTP via SMS
        await sendOTP(phoneNumber: phoneNumber);

        _controller.add(AuthStatus.continueSignup);
      } else {
        _controller.add(AuthStatus.unknown);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  /// Verify Sign-Up [verifySignup]
  @override
  Future<void> verifySignup({required String phoneNumber}) async {
    try {
      Response<dynamic> res =
          await _authPost(EndPoints.confirmViaSMS, {'number': phoneNumber});

      if (res.statusCode == 200) {
        // Sign-In User after successful SIGNUP Verification
        logIn(
          emailOrPhone: currentSignup.email,
          password: currentSignup.password,
        ).whenComplete(() {
          _cache.deleteCache(key: signupIdCacheKey);
          _cache.deleteCache(key: otpSignupCacheKey);
        });
      }
    } on DioException catch (_) {
      // debugPrint("logout error: catch ......");
    }
  }

  @override
  Future<void> sendOTP({
    String? otpCode,
    String? phoneNumber,
    bool resendOTP = false,
  }) async {
    try {
      String otp = otpCode ?? generateOTP();

      final otpExpiry = addExtraTime(const Duration(seconds: 61));

      // Save OTP in Cache
      _cache.writeCache(key: otpSignupCacheKey, data: {
        'otp': otp,
        'otpExpiry': otpExpiry,
      });
      /*SMSConfigModel smsConfig = _appLocalService.smsConfigCache;
      debugPrint("$otp-----$smsConfig");*/

      // debugPrint("$otp-----$otp");
      if (resendOTP) {
        _controller.add(AuthStatus.otpCreated);
      }

      await _authPost(
        EndPoints.naloUrl,
        {
          "key": EndPoints.naloSMSApiKey,
          "msisdn": phoneNumber ?? currentSignup.phoneNumber,
          "sender_id": EndPoints.naloSmsSenderID,
          "message":
              "$appName Signup Verification Code is: $otp. Do not share with anyone.",
        },
      );
    } on DioException catch (e) {
      debugPrint("sms: catch ...... $e");
    } catch (e) {
      debugPrint("text-sms: catch ...... $e");
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final accessToken = _cache.readCache(key: accessTokenCacheKey);
      _dio.options.headers["Authorization"] = "Bearer $accessToken";
      _dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await _dio.postUri(Uri.parse(EndPoints.logout));
      if (response.statusCode == 200) {
        await Future.wait([
          // clear cache
          _cache.deleteCache(key: userCacheKey),
          _cache.deleteCache(key: signupIdCacheKey),

          // Re-Generate new Temporal AccessToken
          temporalToken()
        ]);
        // session status: unauthenticated
        _controller.add(AuthStatus.unauthenticated);
      }
    } on DioException catch (_) {
      // debugPrint("logout error: catch ......");
    }
  }

  void dispose() => _controller.close();
}
