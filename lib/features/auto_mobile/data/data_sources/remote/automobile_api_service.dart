import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/auth_interceptor.dart';
import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';

part 'automobile_api_service.g.dart';

/* Run this CMD to generate
[part 'automobile_api_service.g.dart'] file:
dart run build_runner build */

@RestApi(baseUrl: automobileAPIBaseURL)
abstract class AutomobileApiService {
  factory AutomobileApiService(Dio dio) = _AutomobileApiService;

  /// Vehicle Make \\\

  // Get All Vehicle/Car Make
  @GET('$devPath/car_makes')
  Future<HttpResponse<List<MakeModel>>> getMakes({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  /// Vehicle Model \\\

  // Get All Vehicle/Car Model
  @GET('$devPath/car_models')
  Future<HttpResponse<List<Model>>> getModels({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car Model By Make Reference
  @GET('$devPath/car_models/make_ref/{makeRef}')
  Future<HttpResponse<List<Model>>> getModelsByMakeRef({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('makeRef') String? makeRef,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  /// Vehicles/Cars \\\

  // Get All Vehicles/Cars
  @GET('$devPath/auto_cars')
  Future<HttpResponse<List<VehicleModel>>> getVehicles({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car by VIN
  @GET('$devPath/auto_cars/{vin}')
  Future<HttpResponse<VehicleModel>> getVehicleByVin({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vin') String? vin,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car by vehicleCode
  @GET('$devPath/auto_cars/v_code/{vehicleCode}')
  Future<HttpResponse<VehicleModel>> getVehicleByVic({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vehicleCode') String? vehicleCode,
  });

  /// Parts \\\

  // Get Parts by VFAM
  @GET('$devPath/car_parts')
  Future<HttpResponse<List<PartModel>>> getParts({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get All Parts
  @GET('$devPath/car_parts/{vfam}')
  Future<HttpResponse<List<PartModel>>> getPartsByVFam({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vfam') String? vfam,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Parts by HunterNo
  @GET('$devPath/car_parts/hunter/{hunterNo}')
  Future<HttpResponse<PartModel>> getPartByHunterNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('hunterNo') String? hunterNo,
  });

  // Get Parts by Make & Model
  @GET('$devPath/car_parts/{make}/{model}')
  Future<HttpResponse<List<PartModel>>> getPartsByVMakeModel({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('make') String? make,
    @Path('model') String? model,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Parts Years By Make & Model
  @GET('$devPath/car_parts/year_range/{make}/{model}')
  Future<HttpResponse<List<int>>> getPartsYearsByMakeModel({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('make') String? make,
    @Path('model') String? model,
  });

  /// Hunter (CrossRef) \\\

  // Get All Hunter
  @GET('$devPath/parts_hunter')
  Future<HttpResponse<List<HunterModel>>> getHunters({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Hunter by hunter-no
  @GET('$devPath/parts_hunter/{hunterNo}')
  Future<HttpResponse<List<HunterModel>>> getHunterPartsByHunterNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('hunterNo') String? hunterNo,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Hunter by car-part-no
  @GET('$devPath/parts_hunter/part_no/{partNo}')
  Future<HttpResponse<List<HunterModel>>> getHunterPartsByPartNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('partNo') String? partNo,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  /// Vendors \\\

  // Get All Vendors Parts
  @GET('$devPath/vendors_parts')
  Future<HttpResponse<List<VendorModel>>> getVendors({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vendor by ID
  @GET('$devPath/vendors_parts/{id}')
  Future<HttpResponse<VendorModel>> getVendorById({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('id') int? id,
  });

  // Get Vendors Parts By brand & PartNo Reference
  @GET('$devPath/vendors_parts/lowest_price/{brand}/{partNo}')
  Future<HttpResponse<List<VendorModel>>> getVendorPartsByBrandPartNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('brand') String? brand,
    @Path('partNo') String? partNo,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });
}
