import 'dart:io';

import 'package:automasters/core/constants/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  VehicleRepositoryImpl(this._automobileApiService);

  /// Check for Valid Response [_responseValid]
  bool _responseValid<T>(HttpResponse<T> httpRes) =>
      httpRes.response.data != null &&
      httpRes.response.statusCode == HttpStatus.ok;

  /// Get Remote Vehicles from API
  @override
  Future<DataState<List<VehicleModel>>> getVehicles() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getVehicles(
        contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
        page: pagerPage,
        size: pagerSize,
        sort: "id,$orderAsc",
      );

      if (_responseValid<List<VehicleModel>>(httpResponse)) {
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

  /// Get VehicleByVIN
  @override
  Future<DataState<VehicleModel>> getVehicleByVin(String vin) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getVehicleByVin(
        contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
        vin: vin,
      );

      if (_responseValid<VehicleModel>(httpResponse)) {
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

  /// Get VehicleByVIC
  @override
  Future<DataState<VehicleModel>> getVehicleByVic(String vehicleCode) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getVehicleByVic(
        contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
        vehicleCode: vehicleCode,
      );

      if (_responseValid<VehicleModel>(httpResponse)) {
        //print("success httpResponse-> ${httpResponse.response.data}");
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
