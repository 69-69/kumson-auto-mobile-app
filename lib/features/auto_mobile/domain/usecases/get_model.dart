import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/model_repository.dart';

class GetModelsUseCase implements UseCase<DataState<List<ModelEntity>>, void>{
  final ModelRepository _modelRepository;

  GetModelsUseCase(this._modelRepository);

  @override
  Future<DataState<List<ModelEntity>>> call({void params}) {
    return _modelRepository.getModels();
  }

}

class GetModelsByMakeRefUseCase implements UseCase<DataState<List<ModelEntity>>, String>{
  final ModelRepository _modelRepository;

  GetModelsByMakeRefUseCase(this._modelRepository);

  @override
  Future<DataState<List<ModelEntity>>> call({String? params}) {
    return _modelRepository.getModelsByMakeRef(params ?? "not-found");
  }
}