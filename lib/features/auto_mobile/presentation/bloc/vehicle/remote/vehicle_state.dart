import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VehiclesState extends Equatable {
  final List<VehicleEntity>? vehicles;
  final VehicleEntity? vehicle;
  final DioException? error;

  const VehiclesState({this.vehicles, this.vehicle, this.error});

  @override
  List<Object> get props => [vehicles ?? [], vehicle ?? [], error ?? []];
}

class VehiclesLoading extends VehiclesState {
  const VehiclesLoading();
}

/// Vehicles Done
class VehiclesDone extends VehiclesState {
  const VehiclesDone(List<VehicleEntity> vehicles) : super(vehicles: vehicles);
}

/// VehicleBy{vehicleCode or VIN} Done
class VehicleByDone extends VehiclesState {
  const VehicleByDone(VehicleEntity vehicle) : super(vehicle: vehicle);
}

class VehiclesError extends VehiclesState {
  const VehiclesError(DioException error) : super(error: error);
}
