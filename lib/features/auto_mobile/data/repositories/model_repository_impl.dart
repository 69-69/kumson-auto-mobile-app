import 'dart:io';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/model_repository.dart';
import 'package:dio/dio.dart';

class ModelRepositoryImpl implements ModelRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  ModelRepositoryImpl(this._automobileApiService);

  @override
  Future<DataState<List<ModelEntity>>> getModels() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getModels(
          contentType: customHeaders["Content-Type"],
          authToken: accessToken,
          // customHeaders["Authorization"],
          page: pagerPage,
          size: pagerSize,
          sort: "model,$pagerOrder");

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
  Future<DataState<List<ModelEntity>>> getModelsByMakeRef(
      String makeRef) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getModelsByMakeRef(
          contentType: customHeaders["Content-Type"],
          authToken: accessToken,
          // customHeaders["Authorization"],
          makeRef: makeRef,
          page: pagerPage,
          size: pagerSize,
          sort: "model,$pagerOrder");

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        // print("httpResponse-> ${httpResponse.response.data}");
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
