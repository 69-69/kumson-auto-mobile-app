import 'dart:io';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/domain/entities/make.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/make_repository.dart';
import 'package:dio/dio.dart';

class MakeRepositoryImpl implements MakeRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  MakeRepositoryImpl(this._automobileApiService);

  /// Get Remote Makes from API
  @override
  Future<DataState<List<MakeEntity>>> getMakes() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getMakes(
          contentType: customHeaders["Content-Type"],
          authToken: "Bearer $accessToken",
          // customHeaders["Authorization"],
          page: pagerPage,
          size: pagerSize,
          sort: "make,$pagerOrder");

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
