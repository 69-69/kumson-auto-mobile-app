// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automobile_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AutomobileApiService implements AutomobileApiService {
  _AutomobileApiService(
    this._dio, {
    // ignore: unused_element
    this.baseUrl,
  }) {
    baseUrl ??= automobileAPIBaseURL;
  }

  Dio _dio;
  String? baseUrl;

  @override
  Future<HttpResponse<List<MakeModel>>> getMakes({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<MakeModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_makes',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => MakeModel.fromJson(i as Map<String, dynamic>));
    List<MakeModel> value = List<MakeModel>.from(json);*/

    List<MakeModel> value = MakeModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<Model>>> getModels({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<Model>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_models',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));

    /*var json = _result.data!['content']
        .map((dynamic i) => Model.fromJson(i as Map<String, dynamic>));
    List<Model> value = List<Model>.from(json);*/

    List<Model> value = Model.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<Model>>> getModelsByMakeRef({
    String? contentType,
    String? authToken,
    String? makeRef,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<Model>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_models/make_ref/${makeRef}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));

    /*var json = _result.data!['content'];
    json.map((dynamic i) => Model.fromJson(i as Map<String, dynamic>));
    List<Model> value = List<Model>.from(json);*/

    List<Model> value = Model.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<VehicleModel>>> getVehicles({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<VehicleModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/auto_cars',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));

    /*var json = _result.data!['content']
        .map((dynamic i) => VehicleModel.fromJson(i as Map<String, dynamic>));
    List<VehicleModel> value = List<VehicleModel>.from(json);*/

    List<VehicleModel> value =
        VehicleModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<VehicleModel>> getVehicleByVin({
    String? contentType,
    String? authToken,
    String? vin,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<VehicleModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/auto_cars/${vin}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VehicleModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<VehicleModel>> getVehicleByVic({
    String? contentType,
    String? authToken,
    String? vehicleCode,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<VehicleModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/auto_cars/v_code/${vehicleCode}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VehicleModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<PartModel>>> getParts({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<PartModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_parts',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var value = _result.data!
        .map((dynamic i) => PartModel.fromJson(i as Map<String, dynamic>))
        .toList();

        var json = _result.data!['content']
        .map((dynamic i) => PartModel.fromJson(i as Map<String, dynamic>));
    List<PartModel> value = List<PartModel>.from(json);*/

    List<PartModel> value = PartModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<PartModel>>> getPartsByVFam({
    String? contentType,
    String? authToken,
    String? vfam,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<PartModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_parts/${vfam}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => PartModel.fromJson(i as Map<String, dynamic>));
    List<PartModel> value = List<PartModel>.from(json);*/

    List<PartModel> value = PartModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<PartModel>> getPartByHunterNo({
    String? contentType,
    String? authToken,
    String? hunterNo,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<PartModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_parts/hunter/${hunterNo}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PartModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<PartModel>>> getPartsByVMakeModel({
    String? contentType,
    String? authToken,
    String? make,
    String? model,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<PartModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_parts/${make}/${model}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => PartModel.fromJson(i as Map<String, dynamic>));
    List<PartModel> value = List<PartModel>.from(json);*/

    List<PartModel> value = PartModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<int>>> getPartsYearsByMakeModel({
    String? contentType,
    String? authToken,
    String? make,
    String? model,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<HttpResponse<List<int>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/car_parts/year_range/${make}/${model}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data!.cast<int>();
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<HunterModel>>> getHunters({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<HunterModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/parts_hunter',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => HunterModel.fromJson(i as Map<String, dynamic>));
    List<HunterModel> value = List<HunterModel>.from(json);*/

    List<HunterModel> value =
        HunterModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<HunterModel>>> getHunterPartsByHunterNo({
    String? contentType,
    String? authToken,
    String? hunterNo,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<HunterModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/parts_hunter/${hunterNo}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => HunterModel.fromJson(i as Map<String, dynamic>));
    List<HunterModel> value = List<HunterModel>.from(json);*/

    List<HunterModel> value =
        HunterModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<HunterModel>>> getHunterPartsByPartNo({
    String? contentType,
    String? authToken,
    String? partNo,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<HunterModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
      // validateStatus: (_) => true,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/parts_hunter/part_no/${partNo}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => HunterModel.fromJson(i as Map<String, dynamic>));
    List<HunterModel> value = List<HunterModel>.from(json);*/

    List<HunterModel> value =
        HunterModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<VendorModel>>> getVendors({
    String? contentType,
    String? authToken,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<VendorModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/vendors_parts',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => VendorModel.fromJson(i as Map<String, dynamic>));
    List<VendorModel> value = List<VendorModel>.from(json);*/

    List<VendorModel> value =
        VendorModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<VendorModel>> getVendorById({
    String? contentType,
    String? authToken,
    int? id,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<VendorModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/vendors_parts/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VendorModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<List<VendorModel>>> getVendorPartsByBrandPartNo({
    String? contentType,
    String? authToken,
    String? brand,
    String? partNo,
    int? page,
    int? size,
    String? sort,
  }) async {
    _dio = AuthInterceptor.getInstance();

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'sort': sort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': contentType,
      r'Authorization': authToken,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<List<VendorModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/test/runner/2023/k1/vendors_parts/lowest_price/${brand}/${partNo}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    /*var json = _result.data!['content']
        .map((dynamic i) => VendorModel.fromJson(i as Map<String, dynamic>));
    List<VendorModel> value = List<VendorModel>.from(json);*/

    List<VendorModel> value =
        VendorModel.fromJsonList(_result.data!['content']);

    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
