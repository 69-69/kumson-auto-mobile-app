import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vehicle_repository.dart';

// All Vehicles
class GetVehicleUseCase implements UseCase<DataState<List<VehicleEntity>>, void>{
  final VehicleRepository _vehicleRepository;

  GetVehicleUseCase(this._vehicleRepository);

  @override
  Future<DataState<List<VehicleEntity>>> call({void params}) async {
    return await _vehicleRepository.getVehicles();
  }
}

// Vehicle By VIN
class GetVehicleByVinUseCase implements UseCase<DataState<VehicleEntity>, String>{
  final VehicleRepository _vehicleRepository;

  GetVehicleByVinUseCase(this._vehicleRepository);

  @override
  Future<DataState<VehicleEntity>> call({String? params}) async {
    return await _vehicleRepository.getVehicleByVin(params ?? "not-found");
  }
}

// Vehicle By vehicleCode
class GetVehicleByVicUseCase implements UseCase<DataState<VehicleEntity>, String>{
  final VehicleRepository _vehicleRepository;

  GetVehicleByVicUseCase(this._vehicleRepository);

  @override
  Future<DataState<VehicleEntity>> call({String? params}) async {
    return await _vehicleRepository.getVehicleByVic(params ?? "not-found");
  }
}