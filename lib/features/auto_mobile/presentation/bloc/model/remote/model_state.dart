import 'package:automasters/features/auto_mobile/domain/entities/model.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ModelsState extends Equatable {
  final List<ModelEntity>? models;
  final ModelEntity? model;
  final DioException? error;

  const ModelsState({this.models, this.model, this.error});

  @override
  List<Object> get props => [models ?? [], model ?? [], error ?? []];
}

class ModelsLoading extends ModelsState {
  const ModelsLoading();
}

/// Many Models Done
class ModelsDone extends ModelsState {
  const ModelsDone(List<ModelEntity> models) : super(models: models);
}

/// One ModelBy Done
class ModelByDone extends ModelsState {
  const ModelByDone(ModelEntity model) : super(model: model);
}

class ModelsError extends ModelsState {
  const ModelsError(DioException error) : super(error: error);
}
