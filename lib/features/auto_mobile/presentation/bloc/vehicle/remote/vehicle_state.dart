import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleState<T> extends Equatable {
  final T? vehicle;
  final DioException? error;

  const VehicleState({this.vehicle, this.error});

  @override
  List<Object?> get props => [vehicle, error];
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

/// Vehicles Done
class VehicleDone<T> extends VehicleState<T> {
  const VehicleDone(T vehicle) : super(vehicle: vehicle);
}

class VehicleError extends VehicleState {
  const VehicleError(DioException error) : super(error: error);
}
