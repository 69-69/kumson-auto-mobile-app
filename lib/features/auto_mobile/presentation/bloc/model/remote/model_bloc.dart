import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_model.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Models Bloc
class ModelsBloc extends Bloc<ModelsEvent, ModelsState> {
  final GetModelsUseCase _getModelsUseCase;

  ModelsBloc(this._getModelsUseCase) : super(const ModelsLoading()) {
    on<GetModelsEvent>(onGetModels);
  }

  void onGetModels(GetModelsEvent event, Emitter<ModelsState> emit) async {
    final dataState = await _getModelsUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ModelsDone<List<ModelEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(ModelsError(dataState.error!));
    }
  }
}

/// GetModelByMakeRef Bloc
class ModelsByMakeRefBloc extends Bloc<ModelsEvent, ModelsState> {
  final GetModelsByMakeRefUseCase _getModelsByMakeRefUseCase;

  ModelsByMakeRefBloc(this._getModelsByMakeRefUseCase) : super(const ModelsLoading()) {
    on<GetModelsByEvent>(
      onGetModelsByMakeRef,
      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void onGetModelsByMakeRef(GetModelsByEvent event, Emitter<ModelsState> emit) async {
    final dataState = await _getModelsByMakeRefUseCase.call(params: event.makeRef);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ModelsDone<List<ModelEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(ModelsError(dataState.error!));
    }
  }
}

