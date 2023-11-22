import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Vehicles Bloc
class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehicleUseCase _getVehicleUseCase;

  VehiclesBloc(this._getVehicleUseCase) : super(const VehiclesLoading()) {
    on<GetVehiclesEvent>(onGetVehicles);
  }

  void onGetVehicles(
      GetVehiclesEvent event, Emitter<VehiclesState> emit) async {
    final dataState = await _getVehicleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehiclesDone<List<VehicleEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehiclesError(dataState.error!));
    }
  }
}

/// VIN:: VehicleByVin Bloc
class VehicleByVinBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehicleByVinUseCase _getVehicleByVinUseCase;

  VehicleByVinBloc(this._getVehicleByVinUseCase)
      : super(const VehiclesLoading()) {
    on<GetVehicleByVinEvent>(
      onGetVehicleByVin,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void onGetVehicleByVin(
      GetVehicleByVinEvent event, Emitter<VehiclesState> emit) async {
    final dataState = await _getVehicleByVinUseCase.call(params: event.vin);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehiclesDone<VehicleEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehiclesError(dataState.error!));
    }
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<VehiclesState> change) {
    super.onChange(change);
    debugPrint("Vehicle-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<VehiclesEvent, VehiclesState> transition) {
    super.onTransition(transition);
    debugPrint("Vehicle-Bloc: $transition\n\n");
  }
}

/// vehicleCode:: GetVehicleByVic Bloc
class VehicleByVicBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehicleByVicUseCase _getVehicleByVicUseCase;

  VehicleByVicBloc(this._getVehicleByVicUseCase)
      : super(const VehiclesLoading()) {
    on<GetVehicleByVicEvent>(
      onGetVehicleByVic,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void onGetVehicleByVic(
      GetVehicleByVicEvent event, Emitter<VehiclesState> emit) async {
    final dataState =
        await _getVehicleByVicUseCase.call(params: event.vehicleCode);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehiclesDone<VehicleEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehiclesError(dataState.error!));
    }
  }
}
