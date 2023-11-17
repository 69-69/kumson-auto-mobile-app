import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/auth_interceptor.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl {
  final AppLocalDatabase _appLocalDatabase = AppLocalDatabase();

  // Check if API is Online / Offline
  static Future<bool> isAPILive() async {
    var response = await Dio().get(isAPILiveUrl);
    return response.statusCode == 200 ? true : false;
  }

  Future<List<dynamic>?> getData(String query, String endPoint) async {
    try {
      var dio = AuthInterceptor.getInstance();
      final String apiUrl =
          "$automobileAPIBaseURL/test/runner/2023/k1/$endPoint";
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      dio.options.headers["Content-Type"] = customHeaders["Content-Type"];

      var response = await dio.get(apiUrl/*, data: {"query": query},*/);

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        return response.data!['content'];
      } else {
        return null;
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
      return null;
    }

  }

  /// Get Remote Makes from API
  Future<List<HunterModel>?> getHunterPartsByPartNo(String partNo) async {
    try {
      var dio = AuthInterceptor.getInstance();
      final String apiUrl =
          "$automobileAPIBaseURL$devPath/parts_hunter/part_no/$partNo";
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      dio.options.headers["Content-Type"] = customHeaders["Content-Type"];

      var response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        List jsonList = response.data['content'];

        return HunterModel.fromJsonList(jsonList);
      } else {
        return null;
      }
    } on DioException catch (_) {
      //debugPrint(e.toString());
      return null;
    }
  }

  Future<VehicleModel?> getVehicleByVin(String vin) async {
    try {
      var dio = AuthInterceptor.getInstance();
      final String apiUrl = "$automobileAPIBaseURL$devPath/auto_cars/$vin";
      // Get AccessToken from App localStorage
      final accessToken = _appLocalDatabase.readData(key: accessTokenKey);
      dio.options.headers["Authorization"] = "Bearer $accessToken";
      // dio.options.connectTimeout = Duration(seconds: 5000);
      // dio.options.receiveTimeout = Duration(seconds: 5000);
      dio.options.headers["Content-Type"] = customHeaders["Content-Type"];

      var response = await dio.getUri(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // debugPrint("httpResponse-> ${response.data}");

        return VehicleModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (_) {
      return null;
    }
  }
}
