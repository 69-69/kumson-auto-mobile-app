import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_parts.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Parts Bloc
class PartsBloc extends Bloc<PartEvent, PartState> {
  final GetPartsUseCase _getPartsUseCase;

  PartsBloc(this._getPartsUseCase) : super(const PartLoading()) {
    on<GetPartsEvent>(
      _onGetParts,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void _onGetParts(GetPartsEvent event, Emitter<PartState> emit) async {
    final dataState = await _getPartsUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PartDone<List<PartEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartError(dataState.error!));
    }
  }
}

/// PartsByHunterNo Bloc
class PartByHunterNoBloc extends Bloc<PartEvent, PartState> {
  final GetPartByHunterNoUseCase _getPartByHunterNoUseCase;

  PartByHunterNoBloc(this._getPartByHunterNoUseCase)
      : super(const PartLoading()) {
    on<GetPartByHunterNoEvent>(
      _onGetPartByHunterNo,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetPartByHunterNo(
    GetPartByHunterNoEvent event,
    Emitter<PartState> emit,
  ) async {
    try {
      final dataState =
          await _getPartByHunterNoUseCase.call(params: event.hunterNo);

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(PartDone<PartEntity>(dataState.data!));
      }
    } on DataFailed catch (e) {
      // debugPrint("DataFailed-> ${e.error!.message}");
      emit(PartError(e.error!));
    } catch (_) {}

    /*final dataState =
        await _getPartByHunterNoUseCase.call(params: event.hunterNo);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      // pass the data
      emit(PartDone<PartEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(PartError(dataState.error!));
    }*/
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<PartState> change) {
    super.onChange(change);
    debugPrint("Parts-HunterNo-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<PartEvent, PartState> transition) {
    super.onTransition(transition);
    debugPrint("Parts-HunterNo-Bloc: $transition\n\n");
  }
}

/// PartsByVFam Bloc
class PartsByVFamBloc extends Bloc<PartEvent, PartState> {
  final GetPartsByVFamUseCase _getPartsByVFamUseCase;

  PartsByVFamBloc(this._getPartsByVFamUseCase) : super(const PartLoading()) {
    on<GetPartsByVFamEvent>(
      _onGetPartsByVFam,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetPartsByVFam(
    GetPartsByVFamEvent event,
    Emitter<PartState> emit,
  ) async {
    try {
      final dataState = await _getPartsByVFamUseCase.call(params: event.vfam);
      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(PartDone<List<PartEntity>>(dataState.data!));
      }
    } on DataFailed catch (e) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<PartState> change) {
    super.onChange(change);
    debugPrint("Parts-VFam-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<PartEvent, PartState> transition) {
    super.onTransition(transition);
    debugPrint("Parts-VFam-Bloc: $transition\n\n");
  }
}

/// PartsByMakeModel Bloc
class PartsByMakeModelBloc extends Bloc<PartEvent, PartState> {
  final GetPartsByMakeModelUseCase _getPartsByMakeModelUseCase;

  PartsByMakeModelBloc(this._getPartsByMakeModelUseCase)
      : super(const PartLoading()) {
    on<GetByMakeModelEvent>(
      _onGetPartsByMakeModel,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetPartsByMakeModel(
    GetByMakeModelEvent event,
    Emitter<PartState> emit,
  ) async {
    try {
      PartEntity params = PartEntity(make: event.make, model: event.model);
      final dataState = await _getPartsByMakeModelUseCase.call(params: params);

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(PartDone<List<PartEntity>>(dataState.data!));
      }
    } on DataFailed catch (e) {
      emit(PartError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<PartState> change) {
    super.onChange(change);
    debugPrint("Parts-MakeModel-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<PartEvent, PartState> transition) {
    super.onTransition(transition);
    debugPrint("Parts-MakeModel-Bloc: $transition\n\n");
  }
}

/// PartsYearsByMakeModel Bloc
class PartsYearsByMakeModelBloc extends Bloc<PartEvent, PartState> {
  final GetPartsYearsByMakeModelUseCase _getYearsByMakeModelUseCase;

  PartsYearsByMakeModelBloc(this._getYearsByMakeModelUseCase)
      : super(const PartLoading()) {
    on<GetByMakeModelEvent>(
      _onGetPartsYearsByMakeModel,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetPartsYearsByMakeModel(
    GetByMakeModelEvent event,
    Emitter<PartState> emit,
  ) async {
    try {
      PartEntity params = PartEntity(make: event.make, model: event.model);
      final dataState = await _getYearsByMakeModelUseCase.call(params: params);

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(PartDone<List<int>>(dataState.data!));
      }
    } on DataFailed catch (e) {
      emit(PartError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<PartState> change) {
    super.onChange(change);
    debugPrint("Parts-Years-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<PartEvent, PartState> transition) {
    super.onTransition(transition);
    debugPrint("Parts-Years-Bloc: $transition\n\n");
  }
}
