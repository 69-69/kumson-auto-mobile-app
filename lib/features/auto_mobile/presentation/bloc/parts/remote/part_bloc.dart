import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_parts.dart';

/// Parts Bloc
class PartsBloc extends Bloc<PartsEvent, PartsState> {
  final GetPartsUseCase _getPartsUseCase;

  PartsBloc(this._getPartsUseCase) : super(const PartsLoading()) {
    on<GetParts>(onGetParts);
  }

  void onGetParts(GetParts event, Emitter<PartsState> emit) async {
    final dataState = await _getPartsUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PartsDone<PartEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartsError(dataState.error!));
    }
  }
}

/// PartsByHunterNo Bloc
class PartByHunterNoBloc extends Bloc<PartsEvent, PartsState> {
  final GetPartByHunterNoUseCase _getPartByHunterNoUseCase;

  PartByHunterNoBloc(this._getPartByHunterNoUseCase)
      : super(const PartsLoading()) {
    on<GetPartByHunterNo>(
      onGetPartByHunterNo,
      transformer: debounce(),
    );
  }

  void onGetPartByHunterNo(
      GetPartByHunterNo event, Emitter<PartsState> emit) async {
    final dataState =
        await _getPartByHunterNoUseCase.call(params: event.hunterNo);

    if (dataState is DataSuccess && dataState.data!.hunter!.isNotEmpty) {
      // pass the data
      emit(PartByDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the error
      emit(PartsError(dataState.error!));
    }
  }
}

/// PartsByVFam Bloc
class PartsByVFamBloc extends Bloc<PartsEvent, PartsState> {
  final GetPartsByVFamUseCase _getPartsByVFamUseCase;

  PartsByVFamBloc(this._getPartsByVFamUseCase) : super(const PartsLoading()) {
    on<GetPartsByVFam>(
      onGetPartsByVFam,
      transformer: debounce(),
    );
  }

  void onGetPartsByVFam(GetPartsByVFam event, Emitter<PartsState> emit) async {
    final dataState = await _getPartsByVFamUseCase.call(params: event.vfam);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PartsDone<PartEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartsError(dataState.error!));
    }
  }
}

/// PartsByMakeModel Bloc
class PartsByMakeModelBloc extends Bloc<PartsEvent, PartsState> {
  final GetPartsByMakeModelUseCase _getPartsByMakeModelUseCase;

  PartsByMakeModelBloc(this._getPartsByMakeModelUseCase)
      : super(const PartsLoading()) {
    on<GetByMakeModel>(
      onGetPartsByMakeModel,
      transformer: debounce(),
    );
  }

  void onGetPartsByMakeModel(GetByMakeModel event, Emitter<PartsState> emit) async {
    PartEntity params = PartEntity(make: event.make, model: event.model);
    final dataState = await _getPartsByMakeModelUseCase.call(params: params);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PartsDone<PartEntity>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartsError(dataState.error!));
    }
  }
}

/// PartsYearsByMakeModel Bloc
class PartsYearsByMakeModelBloc extends Bloc<PartsEvent, PartsState> {
  final GetPartsYearsByMakeModelUseCase _getYearsByMakeModelUseCase;

  PartsYearsByMakeModelBloc(this._getYearsByMakeModelUseCase)
      : super(const PartsLoading()) {
    on<GetByMakeModel>(
      onGetPartsYearsByMakeModel,
      transformer: debounce(),
    );
  }

  void onGetPartsYearsByMakeModel(GetByMakeModel event, Emitter<PartsState> emit) async {
    PartEntity params = PartEntity(make: event.make, model: event.model);
    final dataState = await _getYearsByMakeModelUseCase.call(params: params);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PartsDone<int>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(PartsError(dataState.error!));
    }
  }
}
