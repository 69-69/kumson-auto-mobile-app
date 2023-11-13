import 'dart:io';

import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vendor_repository.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/constants.dart';

class VendorRepositoryImpl implements VendorRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  VendorRepositoryImpl(this._automobileApiService);

  @override
  Future<DataState<List<VendorModel>>> getVendors() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getVendors(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        page: pagerPage,
        size: pagerSize,
        sort: "currentPrice,$pagerOrder",
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
  Future<DataState<VendorModel>> getVendorById(int id) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse = await _automobileApiService.getVendorById(
          contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
          id: id);

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
  Future<DataState<List<VendorModel>>> getVendorPartsByBrandPartNo(
    String brand,
    String partNo,
  ) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);

      final httpResponse =
          await _automobileApiService.getVendorPartsByBrandPartNo(
        contentType: customHeaders["Content-Type"],
        authToken: "Bearer $accessToken",
        brand: brand,
        partNo: partNo,
        page: pagerPage,
        size: pagerSize,
        sort: "currentPrice,$pagerOrder",
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
