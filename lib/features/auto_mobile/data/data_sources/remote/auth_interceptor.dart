import 'dart:convert';

import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:automasters/features/auto_mobile/data/models/jwt.dart';
import 'package:dio/dio.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor {
  // AuthInterceptor();

  static Dio? _instance;

  //method for getting dio instance
  static Dio getInstance() {
    _instance ??= createDioInstance();
    return _instance!;
  }

  // WhiteList:: list of the endpoints where you don't need to pass a token.
  static final listOfPaths = <String>[
    "$authPath/login",
    "$authPath/register",
    "$authPath/user_exist",
    "$authPath/refresh/token",
    "$authPath/register/confirm_email",
    "$authPath/resend_confirm_email",
  ];

  static Dio createDioInstance() {
    var dio = Dio();

    // adding interceptor
    dio.interceptors
      ..clear()
      //To show logs, register [LogInterceptor], you can also enable and
      // disable response body [LogInterceptor(responseBody: false)]
      //..add(LogInterceptor(requestHeader: false, responseHeader: false))
      ..add(
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            // Check if the requested endpoint match in the
            if (!listOfPaths.contains(options.path.toString())) {
              // if the endpoint is matched then skip adding the token
              return handler.next(options); //modify your request
            }
          },
          onResponse: (response, handler) {
            // ignore: unnecessary_null_comparison
            if (response != null) {
              //on success it is getting called here
              return handler.next(response);
            } else {
              return;
            }
          },
          onError: (DioException e, handler) async {
            if (e.response != null) {
              // 1-> Check the error code(401),
              if (e.response!.statusCode == 401) {
                // catch the 401 here
                // dio.interceptors.requestLock.lock();
                // dio.interceptors.responseLock.lock();

                // 2-> Get new ACCESS-TOKEN
                await refreshToken();

                // 3-> Make a clone of the Previous Request and set new access token
                RequestOptions requestOptions = e.requestOptions;

                AppLocalDatabase repository = AppLocalDatabase();
                var accessToken = repository.readData(key: accessTokenKey);

                final opts = Options(method: requestOptions.method);
                dio.options.headers["Content-Type"] = "*/*";
                dio.options.headers["Authorization"] = "Bearer $accessToken";
                // dio.interceptors.requestLock.unlock();
                // dio.interceptors.responseLock.unlock();

                // 4-> Make the previous call/request again
                // (Re-run the failed user's Request again)
                var reqUrl = requestOptions.baseUrl + requestOptions.path;
                final response = await dio.request(
                  reqUrl,
                  options: opts,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                );
                // ignore: unnecessary_null_comparison
                if (response != null) {
                  return handler.resolve(response);
                } else {
                  return;
                }
              } else {
                return handler.next(e);
              }
            }
          },
        ),
      );
    return dio;
  }

  static refreshToken() async {
    Response response;
    AppLocalDatabase repository = AppLocalDatabase();

    var dio = Dio();
    final Uri apiUrl =
        Uri.parse("$automobileAPIBaseURL/api/v1/auth/refresh/token");
    var refreshToken = repository.readData(key: refreshTokenKey);
    dio.options.headers["Authorization"] = "Bearer $refreshToken";

    try {
      response = await dio.postUri(apiUrl);
      if (response.statusCode == 200) {
        JWTModel refreshTokenResponse =
            JWTModel.fromJson(jsonDecode(response.toString()));
        repository.writeData(
            key: accessTokenKey, data: refreshTokenResponse.accessToken);
        repository.writeData(
            key: refreshTokenKey, data: refreshTokenResponse.refreshToken);
      } else {
        debugPrint("logout:$response"); //TODO: logout
      }
    } catch (e) {
      debugPrint("logout2: $e"); //TODO: logout
    }
  }
}
