import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';

/// Domain -> Repository <- Data
abstract class VehicleRepository {
  /// Remote API Methods Calls ///

  Future<DataState<List<VehicleEntity>>> getVehicles();

  /// Get VehicleByVIN
  Future<DataState<VehicleEntity>> getVehicleByVin(String vin);

  /// Get VehicleByVIC
  Future<DataState<VehicleEntity>> getVehicleByVic(String vehicleCode);
}
