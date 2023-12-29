import 'package:automasters/core/constants/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/dio_util.dart';
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

@RestApi(baseUrl: EndPoints.apiBaseUrl)
abstract class AutomobileApiService {
  factory AutomobileApiService(Dio dio) = _AutomobileApiService;

  /// Vehicle Make \\\

  // Get All Vehicle/Car Make
  @GET(EndPoints.make)
  Future<HttpResponse<List<MakeModel>>> getMakes({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
    // @DioOptions() Options options,
  });

  /// Vehicle Model \\\

  // Get All Vehicle/Car Model
  @GET(EndPoints.model)
  Future<HttpResponse<List<Model>>> getModels({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car Model By Make Reference
  @GET('${EndPoints.modelsByMakeRef}/{makeRef}')
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
  @GET(EndPoints.vehicle)
  Future<HttpResponse<List<VehicleModel>>> getVehicles({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car by VIN
  @GET('${EndPoints.vehicle}/{vin}')
  Future<HttpResponse<VehicleModel>> getVehicleByVin({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vin') String? vin,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vehicle/Car by vehicleCode
  @GET('${EndPoints.vehicleByVic}/{vehicleCode}')
  Future<HttpResponse<VehicleModel>> getVehicleByVic({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vehicleCode') String? vehicleCode,
  });

  /// Parts \\\

  // Get Parts by VFAM
  @GET(EndPoints.part)
  Future<HttpResponse<List<PartModel>>> getParts({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get All Parts
  @GET('${EndPoints.part}/{vfam}')
  Future<HttpResponse<List<PartModel>>> getPartsByVFam({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('vfam') String? vfam,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Parts by HunterNo
  @GET('${EndPoints.partsByHunterNo}/{hunterNo}')
  Future<HttpResponse<PartModel>> getPartByHunterNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('hunterNo') String? hunterNo,
  });

  // Get Parts by Make & Model
  @GET('${EndPoints.part}/{make}/{model}')
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
  @GET('${EndPoints.partsYearsByMakeAndModel}/{make}/{model}')
  Future<HttpResponse<List<int>>> getPartsYearsByMakeModel({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('make') String? make,
    @Path('model') String? model,
  });

  /// Hunter (CrossRef) \\\

  // Get All Hunter
  @GET(EndPoints.hunter)
  Future<HttpResponse<List<HunterModel>>> getHunters({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Hunter by hunter-no
  @GET('${EndPoints.hunter}/{hunterNo}')
  Future<HttpResponse<List<HunterModel>>> getHunterPartsByHunterNo({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('hunterNo') String? hunterNo,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Hunter by car-part-no
  @GET('${EndPoints.huntersByPartNo}/{partNo}')
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
  @GET(EndPoints.vendor)
  Future<HttpResponse<List<VendorModel>>> getVendors({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sort") String? sort,
  });

  // Get Vendor by ID
  @GET('${EndPoints.vendor}/{id}')
  Future<HttpResponse<VendorModel>> getVendorById({
    @Header('Content-Type') String? contentType,
    @Header('Authorization') String? authToken,
    @Path('id') int? id,
  });

  // Get Vendors Parts By brand & PartNo Reference
  @GET('${EndPoints.vendorsByBrandAndPartNo}/{brand}/{partNo}')
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
