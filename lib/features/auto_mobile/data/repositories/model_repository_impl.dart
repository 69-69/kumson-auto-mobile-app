import 'dart:io';

import 'package:automasters/core/constants/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/model_repository.dart';


class ModelRepositoryImpl implements ModelRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  ModelRepositoryImpl(this._automobileApiService);

  /// Check for Valid Response [_responseValid]
  bool _responseValid<T>(HttpResponse<T> httpRes) =>
      httpRes.response.data != null &&
          httpRes.response.statusCode == HttpStatus.ok;
  
  @override
  Future<DataState<List<Model>>> getModels() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getModels(
          contentType: EndPoints.headers["Content-Type"],
          authToken: "Bearer $accessToken",
          page: pagerPage,
          size: pagerSize,
          sort: "model,$orderAsc");

      if (_responseValid<List<Model>>(httpResponse)) {
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
  Future<DataState<List<Model>>> getModelsByMakeRef(
    String makeRef,
  ) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getModelsByMakeRef(
          contentType: EndPoints.headers["Content-Type"],
          authToken: "Bearer $accessToken",
          makeRef: makeRef,
          page: pagerPage,
          size: pagerSize,
          sort: "model,$orderAsc");

      if (_responseValid<List<Model>>(httpResponse)) {
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
