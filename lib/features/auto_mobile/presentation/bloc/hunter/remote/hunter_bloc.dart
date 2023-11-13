import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_Hunter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hunter_event.dart';
import 'hunter_state.dart';

/// Hunters Bloc
class HuntersBloc extends Bloc<HuntersEvent, HuntersState> {
  final GetHuntersUseCase _getHunterUseCase;

  HuntersBloc(this._getHunterUseCase) : super(const HuntersLoading()) {
    on<GetHunters>(onGetHunters);
  }

  void onGetHunters(GetHunters event, Emitter<HuntersState> emit) async {
    final dataState = await _getHunterUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(HuntersDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(HuntersError(dataState.error!));
    }
  }
}

/// HunterPartsByHunterNo Bloc
class HunterPartsByHunterNoBloc extends Bloc<HuntersEvent, HuntersState> {
  final GetHunterPartsByHunterNoUseCase _getHunterPartsByHunterNoUseCase;

  HunterPartsByHunterNoBloc(this._getHunterPartsByHunterNoUseCase)
      : super(const HuntersLoading()) {
    on<GetHunterPartsByHunterNo>(
      onGetHunterPartsByHunterNo,transformer: debounce(),);
  }

  void onGetHunterPartsByHunterNo(
      GetHunterPartsByHunterNo event, Emitter<HuntersState> emit) async {
    final dataState = await _getHunterPartsByHunterNoUseCase.call(
      params: event.hunterNo,
    );

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(HuntersDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(HuntersError(dataState.error!));
    }
  }
}

/// HunterPartsByPartNo Bloc
class HunterPartsByPartNoBloc extends Bloc<HuntersEvent, HuntersState> {
  final GetHunterPartsByPartNoUseCase _getHunterPartsByPartNoUseCase;

  HunterPartsByPartNoBloc(this._getHunterPartsByPartNoUseCase)
      : super(const HuntersLoading()) {
    on<GetHunterPartsByPartNo>(
      onGetHunterPartsByPartNo, transformer: debounce(),
    );
  }

  void onGetHunterPartsByPartNo(
      GetHunterPartsByPartNo event, Emitter<HuntersState> emit) async {
    final dataState = await _getHunterPartsByPartNoUseCase.call(
      params: event.partNo,
    );

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(HuntersDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(HuntersError(dataState.error!));
    }
  }
}
