import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ModelsState<T> extends Equatable {
  // final List<ModelEntity>? models;
  // final ModelEntity? model;
  final T? model;
  final DioException? error;

  const ModelsState({/*this.models,*/ this.model, this.error});

  @override
  List<Object?> get props => [/*models ?? [],*/ model, error];
}

class ModelsLoading extends ModelsState {
  const ModelsLoading();
}

/// Many Models Done
class ModelsDone<T> extends ModelsState<T> {
  const ModelsDone(T models) : super(model: models);
}

/// One ModelBy Done
/*class ModelByDone extends ModelsState {
  const ModelByDone(ModelEntity model) : super(model: model);
}*/

class ModelsError extends ModelsState {
  const ModelsError(DioException error) : super(error: error);
}