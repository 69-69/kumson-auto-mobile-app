import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_model.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Models Bloc
class ModelsBloc extends Bloc<ModelEvent, ModelState> {
  final GetModelsUseCase _getModelsUseCase;

  ModelsBloc(this._getModelsUseCase) : super(const ModelLoading()) {
    on<GetModelsEvent>(
      _onGetModels,
      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void _onGetModels(GetModelsEvent event, Emitter<ModelState> emit) async {
    final dataState = await _getModelsUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ModelDone<List<ModelEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(ModelError(dataState.error!));
    }
  }
}

/// GetModelByMakeRef Bloc
class ModelsByMakeRefBloc extends Bloc<ModelEvent, ModelState> {
  final GetModelsByMakeRefUseCase _getModelsByMakeRefUseCase;

  ModelsByMakeRefBloc(this._getModelsByMakeRefUseCase) : super(const ModelLoading()) {
    on<GetModelsByEvent>(
      _onGetModelsByMakeRef,
      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetModelsByMakeRef(GetModelsByEvent event, Emitter<ModelState> emit,) async {
    try {
    final dataState = await _getModelsByMakeRefUseCase.call(params: event.makeRef);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ModelDone<List<ModelEntity>>(dataState.data!));
    }

    } on DataFailed catch (e) {
      emit(ModelError(e.error!));
    } catch (_) {}
  }
}

