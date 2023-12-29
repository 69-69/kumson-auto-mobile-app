import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/hunter.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/hunter_repository.dart';

class GetHuntersUseCase
    implements UseCase<DataState<List<HunterEntity>>, void> {
  final HunterRepository _hunterRepository;

  GetHuntersUseCase(this._hunterRepository);

  @override
  Future<DataState<List<HunterEntity>>> call({void params}) {
    return _hunterRepository.getHunters();
  }
}

// GetHunterParts By HunterNo
class GetHunterPartsByHunterNoUseCase
    implements UseCase<DataState<List<HunterEntity>>, String> {
  final HunterRepository _hunterRepository;

  GetHunterPartsByHunterNoUseCase(this._hunterRepository);

  @override
  Future<DataState<List<HunterEntity>>> call({String? params}) {
    return _hunterRepository.getHunterPartsByHunterNo(params ?? "not-found");
  }
}

// GetHunterParts By PartNo
class GetHunterPartsByPartNoUseCase
    implements UseCase<DataState<List<HunterEntity>>, String> {
  final HunterRepository _hunterRepository;

  GetHunterPartsByPartNoUseCase(this._hunterRepository);

  @override
  Future<DataState<List<HunterEntity>>> call({String? params}) {
    return _hunterRepository.getHunterPartsByPartNo(params ?? "not-found");
  }
}
