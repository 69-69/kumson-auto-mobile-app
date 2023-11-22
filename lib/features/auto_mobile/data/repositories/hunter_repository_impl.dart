import 'dart:io';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/hunter_repository.dart';
import 'package:dio/dio.dart';

import 'package:retrofit/dio.dart';

class HunterRepositoryImpl implements HunterRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  HunterRepositoryImpl(this._automobileApiService);

  /// Check for Valid Response [_responseValid]
  bool _responseValid<T>(HttpResponse<T> httpRes) =>
      httpRes.response.data != null &&
      httpRes.response.statusCode == HttpStatus.ok;

  @override
  Future<DataState<List<HunterModel>>> getHunters() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getHunterPartsByHunterNo(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        // customHeaders["Authorization"],
        page: pagerPage,
        size: pagerSize,
        sort: "brand,$pagerOrder",
      );

      if (_responseValid<List<HunterModel>>(httpResponse)) {
        //print("httpResponse-> ${httpResponse.response.data}");
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              type: DioExceptionType.badResponse,
              requestOptions: httpResponse.response.requestOptions),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<HunterModel>>> getHunterPartsByHunterNo(
    String hunterNo,
  ) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getHunterPartsByHunterNo(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        // customHeaders["Authorization"],
        hunterNo: hunterNo,
        page: pagerPage,
        size: pagerSize,
        sort: "brand,$pagerOrder",
      );

      if (_responseValid<List<HunterModel>>(httpResponse)) {
        // print("getHunterPartsByHunterNo-Repo-> ${httpResponse.response.data}");
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              type: DioExceptionType.badResponse,
              requestOptions: httpResponse.response.requestOptions),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<HunterModel>>> getHunterPartsByPartNo(
    String partNo,
  ) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getHunterPartsByPartNo(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        // customHeaders["Authorization"],
        partNo: partNo,
        page: pagerPage,
        size: pagerSize,
        sort: "brand,$pagerOrder",
      );

      if (_responseValid<List<HunterModel>>(httpResponse)) {
        //print("httpResponse-> ${httpResponse.response.data}");
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
              error: httpResponse.response.statusMessage,
              response: httpResponse.response,
              type: DioExceptionType.badResponse,
              requestOptions: httpResponse.response.requestOptions),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
