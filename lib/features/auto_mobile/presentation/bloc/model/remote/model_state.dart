import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ModelState<T> extends Equatable {
  // final List<ModelEntity>? models;
  // final ModelEntity? model;
  final T? model;
  final DioException? error;

  const ModelState({/*this.models,*/ this.model, this.error});

  @override
  List<Object?> get props => [/*models ?? [],*/ model, error];
}

class ModelLoading extends ModelState {
  const ModelLoading();
}

/// Many Models Done
class ModelDone<T> extends ModelState<T> {
  const ModelDone(T models) : super(model: models);
}

/// One ModelBy Done
/*class ModelByDone extends ModelsState {
  const ModelByDone(ModelEntity model) : super(model: model);
}*/

class ModelError extends ModelState {
  const ModelError(DioException error) : super(error: error);
}