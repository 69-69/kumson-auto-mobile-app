import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/hunter.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_Hunter.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'hunter_event.dart';
import 'hunter_state.dart';

/// Hunters Bloc
class HuntersBloc extends Bloc<HunterEvent, HunterState> {
  final GetHuntersUseCase _getHunterUseCase;

  HuntersBloc(this._getHunterUseCase) : super(const HunterLoading()) {
    on<GetHuntersEvent>(_onGetHunters);
  }

  void _onGetHunters(GetHuntersEvent event, Emitter<HunterState> emit) async {
    try {
      final dataState = await _getHunterUseCase();

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(HunterDone<List<HunterEntity>>(dataState.data!));
      } else {
        emit(HunterError(dataState.error!));
      }
    } on DataFailed catch (e) {
      emit(HunterError(e.error!));
    } catch (_) {}
  }
}

/// HunterPartsByHunterNo Bloc
class HunterPartsByHunterNoBloc extends Bloc<HunterEvent, HunterState> {
  final GetHunterPartsByHunterNoUseCase _getHunterPartsByHunterNoUseCase;

  HunterPartsByHunterNoBloc(this._getHunterPartsByHunterNoUseCase)
      : super(const HunterLoading()) {
    on<GetHunterPartsByHunterNoEvent>(
      _onGetHunterPartsByHunterNo,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetHunterPartsByHunterNo(
    GetHunterPartsByHunterNoEvent event,
    Emitter<HunterState> emit,
  ) async {
    try {
      final dataState = await _getHunterPartsByHunterNoUseCase.call(
        params: event.hunterNo,
      );

      if (dataState is DataSuccess &&
          dataState.data != null &&
          dataState.data!.isNotEmpty) {
        // debugPrint("steven");
        emit(HunterDone<List<HunterEntity>>(dataState.data!));
      } else {
        emit(HunterError(dataState.error!));
      }
    } on DataFailed catch (e) {
      emit(HunterError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<HunterState> change) {
    super.onChange(change);
    debugPrint("Hunter-Parts-HunterNo-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<HunterEvent, HunterState> transition) {
    super.onTransition(transition);
    debugPrint("Hunter-Parts-HunterNo-Bloc: $transition\n\n");
  }
}

/// HunterPartsByPartNo Bloc
class HunterPartsByPartNoBloc extends Bloc<HunterEvent, HunterState> {
  final GetHunterPartsByPartNoUseCase _getHunterPartsByPartNoUseCase;

  HunterPartsByPartNoBloc(this._getHunterPartsByPartNoUseCase)
      : super(const HunterLoading()) {
    on<GetHunterPartsByPartNoEvent>(
      _onGetHunterPartsByPartNo,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetHunterPartsByPartNo(
      GetHunterPartsByPartNoEvent event, Emitter<HunterState> emit) async {
    try {
      final dataState = await _getHunterPartsByPartNoUseCase.call(
        params: event.partNo,
      );

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(HunterDone<List<HunterEntity>>(dataState.data!));
      } else {
        emit(HunterError(dataState.error!));
      }
    } on DataFailed catch (e) {
      emit(HunterError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<HunterState> change) {
    super.onChange(change);
    debugPrint("Hunter-Parts-PartNo-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<HunterEvent, HunterState> transition) {
    super.onTransition(transition);
    debugPrint("Hunter-Parts-PartNo-Bloc: $transition\n\n");
  }
}
