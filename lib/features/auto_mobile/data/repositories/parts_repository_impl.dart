import 'dart:io';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/parts_repository.dart';
import 'package:dio/dio.dart';

class PartsRepositoryImpl implements PartsRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  PartsRepositoryImpl(this._automobileApiService);

  @override
  Future<DataState<List<PartEntity>>> getParts() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getParts(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
  Future<DataState<PartEntity>> getPartByHunterNo(String hunterNo) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getPartByHunterNo(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        hunterNo: hunterNo,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
  Future<DataState<List<PartEntity>>> getPartsByVFam(String vfam) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getPartsByVFam(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        vfam: vfam,
        page: pagerPage,
        size: pagerSize,
        sort: "part,$pagerOrder",
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
  Future<DataState<List<PartEntity>>> getPartsByVMakeModel(
      String make, String model) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getPartsByVMakeModel(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        make: make,
        model: model,
        page: pagerPage,
        size: pagerSize,
        sort: "part,$pagerOrder",
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
  Future<DataState<List<int>>> getPartsYearsByMakeModel(
      String make, String model) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getPartsYearsByMakeModel(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        make: make,
        model: model,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
