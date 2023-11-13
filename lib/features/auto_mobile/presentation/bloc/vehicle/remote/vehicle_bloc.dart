import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// Vehicles Bloc
class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehicleUseCase _getVehicleUseCase;

  VehiclesBloc(this._getVehicleUseCase) : super(const VehiclesLoading()) {
    on<GetVehicles>(onGetVehicles);
  }

  void onGetVehicles(GetVehicles event, Emitter<VehiclesState> emit) async {
    final dataState = await _getVehicleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VehiclesDone(dataState.data!));
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
    on<GetVehicleByVin>(
      onGetVehicleByVin,
      transformer: debounce(),
    );
  }

  void onGetVehicleByVin(
      GetVehicleByVin event, Emitter<VehiclesState> emit) async {
    final dataState = await _getVehicleByVinUseCase.call(params: event.vin);

    if (dataState is DataSuccess && dataState.data!.vin!.isNotEmpty) {
      emit(VehicleByDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehiclesError(dataState.error!));
    }
  }
}

/// vehicleCode:: GetVehicleByVic Bloc
class VehicleByVicBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehicleByVicUseCase _getVehicleByVicUseCase;

  VehicleByVicBloc(this._getVehicleByVicUseCase)
      : super(const VehiclesLoading()) {
    on<GetVehicleByVic>(
      onGetVehicleByVic,
      transformer: debounce(),
    );
  }

  void onGetVehicleByVic(
      GetVehicleByVic event, Emitter<VehiclesState> emit) async {
    final dataState = await _getVehicleByVicUseCase.call(params: event.vehicleCode);

    if (dataState is DataSuccess && dataState.data!.vehicleCode!.isNotEmpty) {
      emit(VehicleByDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VehiclesError(dataState.error!));
    }
  }
}
