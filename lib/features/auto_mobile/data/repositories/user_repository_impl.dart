import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/core/constants/endpoints.dart';
import 'package:automasters/features/auto_mobile/data/models/user.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/user_repository.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/dio_util.dart';

/// Responsible for the user domain and will expose
/// APIs to interact with the current user [UserRepositoryImpl]

class UserRepositoryImpl implements UserRepository {
  UserModel? _user;
  final AppLocalService _cache = AppLocalService();
  final Dio _dio = DioUtil.getInstance();

  Future<Response<dynamic>> _userGet(
    String apiUrl, {
    dynamic data,
    dynamic queryParams,
  }) async {
    var accessToken = _cache.readCache(key: accessTokenCacheKey);

    _dio.options.headers["Authorization"] = "Bearer $accessToken";
    _dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
    _dio.options.extra = EndPoints.forceDioHttpRefresh;

    final res = await _dio.get(
      apiUrl,
      data: data,
      queryParameters: queryParams,
    );
    return res;
  }

  @override
  Future<UserModel?> getUser() async {
    if (_user != null) return _user;

    try {
      var res = await _userGet(EndPoints.getLoggedInUser);

      if (res.statusCode == 200) {
        var map = createNewMap(jsonDecode(res.toString()));

        _user = UserModel.fromJson(map);

        // save to Cache
        _cache.writeCache(key: userCacheKey, data: map);

        return _user;
      } else {
        return null; // throw Exception(res.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get SMS Config for send Text MSg or SMS
  @override
  Future<void> getSMSConfig() async {
    try {
      var res = await _userGet(EndPoints.smsConfig);

      if (res.statusCode == 200) {
        _cache.writeCache(key: smsConfigKey, data: res.data);
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
    } catch (_) {}
  }

  // Change OTP Mobile/Phone number
  @override
  Future<dynamic> update({
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParam,
  }) async {
    try {
      var res = await _dio.patch(
        EndPoints.user,
        data: data,
        queryParameters: queryParam,
      );

      if (res.statusCode == 200) {
        return res;
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }
}
