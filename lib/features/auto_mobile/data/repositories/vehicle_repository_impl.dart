import 'dart:io';

import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vehicle_repository.dart';
import 'package:dio/dio.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  VehicleRepositoryImpl(this._automobileApiService);

  /// Get Remote Vehicles from API
  @override
  Future<DataState<List<VehicleModel>>> getVehicles() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getVehicles(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        page: pagerPage,
        size: pagerSize,
        sort: "$pagerSort,$pagerOrder",
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

  /// Get VehicleByVIN
  @override
  Future<DataState<VehicleEntity>> getVehicleByVin(String vin) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getVehicleByVin(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        vin: vin,
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

  /// Get VehicleByVIC
  @override
  Future<DataState<VehicleEntity>> getVehicleByVic(String vehicleCode) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getVehicleByVic(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        vehicleCode: vehicleCode,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
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
