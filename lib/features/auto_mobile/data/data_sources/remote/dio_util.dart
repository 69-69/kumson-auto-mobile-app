import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:automasters/core/constants/endpoints.dart';
import 'package:automasters/features/auto_mobile/data/models/jwt.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';

class DioUtil {
  static final _cache = <Uri, Response>{};

  static Dio? _instance;

  //Method for getting dio instance
  // interceptRequest: TRUE -> intercept user's request and add Token
  // interceptRequest: FALSE -> don't intercept user's request
  static Dio getInstance({bool interceptRequest = true}) {
    _instance ??= createDioInstance();
    return interceptRequest ? _instance! : Dio();
  }

  // WhiteList:: list of the endpoints where you don't need to pass a token.
  static final whiteList = EndPoints.whiteList;

  static Dio createDioInstance() {
    var dio = Dio();

    // adding interceptor
    dio.interceptors
      ..clear()
      //To show logs, register [LogInterceptor], you can also enable and
      // disable response body [LogInterceptor(responseBody: false)]
      //..add(LogInterceptor(requestHeader: false, responseHeader: false))
      // ..add(DioCacheManager(CacheConfig(baseUrl: 'YOUR BASE URL')).interceptor)
      ..add(
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            final res = _cache[options.uri];

            // Check if the requested endpoint match in the
            if (!whiteList.contains(options.path)) {
              // if the endpoint is matched then skip adding the token
              return handler.next(options); //modify your request
              /*if (options.extra['refresh'] == true && res == null) {
                // debugPrint('${options.uri}: Force Refresh, Ignore Cache Data! \n');
                return handler.next(options);
              } else if (res != null) {
                // debugPrint('Returned Cache Data: ${options.uri} \n');
                return handler.resolve(res);
              }*/
            }
          },
          onResponse: (response, handler) {
            // ignore: unnecessary_null_comparison
            if (response != null) {
              _cache[response.requestOptions.uri] = response;
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
                AppLocalDatabase repository = AppLocalDatabase();
                // catch the 401 here
                // dio.interceptors.requestLock.lock();
                // dio.interceptors.responseLock.lock();

                // 2-> Get new ACCESS-TOKEN
                await refreshToken(repo: repository);

                // 3-> Make a clone of the Previous Request and set new access token
                RequestOptions requestOptions = e.requestOptions;

                var accessToken =
                    repository.readCache(key: accessTokenCacheKey);

                final opts = Options(method: requestOptions.method);
                dio.options.headers["Content-Type"] =
                    requestOptions.headers["Content-Type"]; //"*/*";
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

  static refreshToken({required AppLocalDatabase repo}) async {
    Response response;

    var dio = getInstance(interceptRequest: false);
    final Uri apiUrl = Uri.parse(EndPoints.refreshTokenUrl);
    var refreshToken = repo.readCache(key: refreshTokenCacheKey);
    dio.options.headers["Authorization"] = "Bearer $refreshToken";

    try {
      response = await dio.postUri(apiUrl);

      if (response.statusCode == 200) {
        JWTModel token = JWTModel.fromJson(jsonDecode(response.toString()));
        AppLocalService().appToken(token);
      } else {
        debugPrint("logout: $response"); //TODO: logout
      }
    } catch (e) {
      debugPrint("logout2: $e"); //TODO: logout
      throw Exception(e);
    }
  }
}
