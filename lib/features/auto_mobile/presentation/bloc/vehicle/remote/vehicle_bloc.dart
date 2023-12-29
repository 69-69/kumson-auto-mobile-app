import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_state.dart';

/// [VehiclesBloc]
class VehiclesBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleUseCase _getVehicleUseCase;

  VehiclesBloc(this._getVehicleUseCase) : super(const VehicleLoading()) {
    on<GetVehiclesEvent>(
      _onGetVehicles,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void _onGetVehicles(
      GetVehiclesEvent event, Emitter<VehicleState> emit) async {
    final dataState = await _getVehicleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehicleDone<List<VehicleEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehicleError(dataState.error!));
    }
  }
}

/// VIN:: [VehicleByVinBloc]
class VehicleByVinBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleByVinUseCase _getVehicleByVinUseCase;

  VehicleByVinBloc(this._getVehicleByVinUseCase)
      : super(const VehicleLoading()) {
    on<GetVehicleByVinEvent>(
      _onGetVehicleByVin,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetVehicleByVin(
    GetVehicleByVinEvent event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      final dataState = await _getVehicleByVinUseCase.call(params: event.vin);

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(VehicleDone<VehicleEntity>(dataState.data!));
      }
    } on DataFailed catch (e) {
      // debugPrint("DataFailed-> ${e.error!.message}");
      emit(VehicleError(e.error!));
    } catch (_) {}

    /*if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehicleDone<VehicleEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      debugPrint("DataFailed-> ${dataState.error!.message}");
      emit(VehicleError(dataState.error!));
    }*/
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<VehicleState> change) {
    super.onChange(change);
    debugPrint("Vehicle-Vin-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<VehicleEvent, VehicleState> transition) {
    super.onTransition(transition);
    debugPrint("Vehicle-Vin-Bloc: $transition\n\n");
  }
}

/// vehicleCode:: [VehicleByVicBloc]
class VehicleByVicBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleByVicUseCase _getVehicleByVicUseCase;

  VehicleByVicBloc(this._getVehicleByVicUseCase)
      : super(const VehicleLoading()) {
    on<GetVehicleByVicEvent>(
      _onGetVehicleByVic,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetVehicleByVic(
      GetVehicleByVicEvent event, Emitter<VehicleState> emit) async {
    try {
    final dataState =
        await _getVehicleByVicUseCase.call(params: event.vehicleCode);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehicleDone<VehicleEntity>(dataState.data!));
    }

    } on DataFailed catch (e) {
      // debugPrint("DataFailed-> ${e.error!.message}");
      emit(VehicleError(e.error!));
    } catch (_) {}
  }
}
