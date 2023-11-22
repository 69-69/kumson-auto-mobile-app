import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VehiclesState<T> extends Equatable {
  final T? vehicle;
  final DioException? error;

  const VehiclesState({this.vehicle, this.error});

  @override
  List<Object?> get props => [vehicle, error];
}

class VehiclesLoading extends VehiclesState {
  const VehiclesLoading();
}

/// Vehicles Done
class VehiclesDone<T> extends VehiclesState<T> {
  const VehiclesDone(T vehicle) : super(vehicle: vehicle);
}

class VehiclesError extends VehiclesState {
  const VehiclesError(DioException error) : super(error: error);
}
