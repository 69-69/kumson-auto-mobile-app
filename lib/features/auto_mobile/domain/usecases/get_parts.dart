import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/parts_repository.dart';

// All Parts UseCase
class GetPartsUseCase implements UseCase<DataState<List<PartEntity>>, void> {
  final PartsRepository _partsRepository;

  GetPartsUseCase(this._partsRepository);

  @override
  Future<DataState<List<PartEntity>>> call({void params}) {
    return _partsRepository.getParts();
  }
}

// PartsByVFam UseCase
class GetPartsByVFamUseCase
    implements UseCase<DataState<List<PartEntity>>, String> {
  final PartsRepository _partsRepository;

  GetPartsByVFamUseCase(this._partsRepository);

  @override
  Future<DataState<List<PartEntity>>> call({String? params}) {
    return _partsRepository.getPartsByVFam(params ?? "not-found");
  }
}

// PartsByHunterNo UseCase
class GetPartByHunterNoUseCase
    implements UseCase<DataState<PartEntity>, String> {
  final PartsRepository _partsRepository;

  GetPartByHunterNoUseCase(this._partsRepository);

  @override
  Future<DataState<PartEntity>> call({String? params}) {
    return _partsRepository.getPartByHunterNo(params ?? "not-found");
  }
}

// Get{Parts or PartsYears} ByMakeModel UseCase
class GetPartsByMakeModelUseCase
    implements UseCase<DataState<List<PartEntity>>, PartEntity> {
  final PartsRepository _partsRepository;

  GetPartsByMakeModelUseCase(this._partsRepository);

  @override
  Future<DataState<List<PartEntity>>> call({PartEntity? params}) {
    return _partsRepository.getPartsByVMakeModel(
        params!.make ?? "", params.model ?? "");
  }
}

// GetByYearsByMakeModel UseCase
class GetPartsYearsByMakeModelUseCase
    implements UseCase<DataState<List<int>>, PartEntity> {
  final PartsRepository _partsRepository;

  GetPartsYearsByMakeModelUseCase(this._partsRepository);

  @override
  Future<DataState<List<int>>> call({PartEntity? params}) {
    return _partsRepository.getPartsYearsByMakeModel(
        params!.make ?? "", params.model ?? "");
  }
}
