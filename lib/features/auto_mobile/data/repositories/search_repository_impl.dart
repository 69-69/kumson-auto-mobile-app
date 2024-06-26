import 'package:dio/dio.dart';
import 'package:automasters/core/constants/endpoints.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/dio_util.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/search_repository.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';

class SearchRepositoryImpl implements SearchRepository {
  final AppLocalDatabase _cache = AppLocalDatabase();
  final Dio _dio = DioUtil.getInstance();

  Future<List<T>> _getData<T>(String apiUrl, {bool hasKey = false}) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);

      _dio.options.headers["Authorization"] = "Bearer $accessToken";
      _dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      _dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await _dio.get(EndPoints.apiBaseUrl + apiUrl);

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        return hasKey ? response.data! : response.data!;
      } else {
        return [];
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<dynamic>> getCarProduct() async =>
      await _getData<dynamic>(EndPoints.product, hasKey: true);

  @override
  Future<List<dynamic>> getCarMake() async => await _getData<dynamic>(
      '${EndPoints.make}?page=0&size=$pagerSize&sort=make,$orderAsc');

  @override
  Future<List<dynamic>> getCarModel(String makeRef) async => await _getData<
          dynamic>(
      '${EndPoints.modelsByMakeRef}/$makeRef?page=0&size=$pagerSize&sort=model,$orderDesc');

  @override
  Future<List<dynamic>> getCarEngineType(String make, String model) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);

      _dio.options.headers["Authorization"] = "Bearer $accessToken";
      _dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      _dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await _dio
          .get('${EndPoints.apiBaseUrl}${EndPoints.part}/$make/$model');

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data['content']}");

        return response.data;
      } else {
        return [];
      }
    } on DioException catch (_) {
      return [];
    }
  }

  @override
  Future<List<int>> getCarYears(String make, String model) async {
    try {
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);

      _dio.options.headers["Authorization"] = "Bearer $accessToken";
      _dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      _dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await _dio.get(
          '${EndPoints.apiBaseUrl}${EndPoints.partsYearsByMakeAndModel}/$make/$model');

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        return response.data!.cast<int>();
      } else {
        return [];
      }
    } on DioException catch (_) {
      return [];
    }
  }

  @override
  Future<VehicleModel?> getVehicleByVin(String vin) async {
    try {
      var dio = DioUtil.getInstance(interceptRequest: false);

      final String apiUrl = "${EndPoints.apiBaseUrl}${EndPoints.vehicle}/$vin";
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      // dio.options.connectTimeout = Duration(seconds: 5000);
      // dio.options.receiveTimeout = Duration(seconds: 5000);
      dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await dio.get(apiUrl);

      // await Future.delayed(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");
        // _cache.writeCache(key: homeSearchDataKey, data: response.data);

        return VehicleModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (_) {
      return null;
    }
  }

  /// Get Remote Makes from API
  @override
  Future<List<dynamic>?> getHunterPartsByPartNo(String partNo) async {
    try {
      var dio = DioUtil.getInstance(interceptRequest: false);

      var baseUrl = EndPoints.apiBaseUrl;
      final String apiUrl = "$baseUrl${EndPoints.huntersByPartNo}/$partNo";
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await dio.get(apiUrl);

      // await Future.delayed(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        List jsonList = response.data;

        var res = await dio.get(
            "$baseUrl${EndPoints.partsByHunterNo}/${jsonList[0]['hunter']}");

        if (res.statusCode == 200) {
          return [
            HunterModel.fromJsonList(jsonList),
            res.data['vin'],
          ];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
      return null;
    }
  }

  /// Get Remote Makes from API
  @override
  Future<List<HunterModel>?> getHunterPartsByPartNo2(String partNo) async {
    try {
      var dio = DioUtil.getInstance(interceptRequest: false);
      // partsByHunterNo
      final String apiUrl =
          "${EndPoints.apiBaseUrl}${EndPoints.huntersByPartNo}/$partNo";
      // Get AccessToken from App localStorage
      final accessToken = _cache.readCache(key: accessTokenCacheKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      dio.options.headers["Content-Type"] = EndPoints.headers["Content-Type"];
      dio.options.extra = EndPoints.forceDioHttpRefresh;

      var response = await dio.get(apiUrl);

      // await Future.delayed(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        List jsonList = response.data;
        return HunterModel.fromJsonList(jsonList);
      } else {
        return null;
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
      return null;
    }
  }
}
