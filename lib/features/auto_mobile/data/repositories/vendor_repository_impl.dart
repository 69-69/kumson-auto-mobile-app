import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:automasters/core/constants/endpoints.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vendor_repository.dart';



class VendorRepositoryImpl implements VendorRepository {
  final AutomobileApiService _automobileApiService;
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  VendorRepositoryImpl(this._automobileApiService);

  /// Check for Valid Response [_responseValid]
  bool _responseValid<T>(HttpResponse<T> httpRes) =>
      httpRes.response.data != null &&
      httpRes.response.statusCode == HttpStatus.ok;

  @override
  Future<DataState<List<VendorModel>>> getVendors() async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getVendors(
        contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
        page: pagerPage,
        size: pagerSize,
        sort: "currentPrice,$orderAsc",
      );

      if (_responseValid<List<VendorModel>>(httpResponse)) {
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
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse = await _automobileApiService.getVendorById(
          contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
          id: id);

      if (_responseValid<VendorModel>(httpResponse)) {
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
      final accessToken = _appLocalDatabase.readCache(key: accessTokenCacheKey);

      final httpResponse =
          await _automobileApiService.getVendorPartsByBrandPartNo(
        contentType: EndPoints.headers["Content-Type"],
        authToken: "Bearer $accessToken",
        brand: brand,
        partNo: partNo,
        page: pagerPage,
        size: pagerSize,
        sort: "currentPrice,$orderAsc",
      );

      if (_responseValid<List<VendorModel>>(httpResponse)) {
        // print("getVendorPartsByBrandPartNo-Repo-> ${httpResponse.response.data}");
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
