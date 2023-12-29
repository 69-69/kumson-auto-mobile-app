import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';

abstract class SearchRepository {
  Future<List<dynamic>> getCarProduct();

  Future<List<dynamic>> getCarMake();

  Future<List<dynamic>> getCarModel(String makeRef);

  Future<List<int>> getCarYears(String make, String model);

  Future<List<dynamic>> getCarEngineType(String make, String model);

  /// Get Remote Makes from API
  Future<List<HunterModel>?> getHunterPartsByPartNo(String partNo);

  Future<VehicleModel?> getVehicleByVin(String vin);
}
