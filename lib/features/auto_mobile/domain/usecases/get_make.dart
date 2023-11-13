import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/make.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/make_repository.dart';


class GetMakesUseCase implements UseCase<DataState<List<MakeEntity>>, void>{
  final MakeRepository _makeRepository;

  GetMakesUseCase(this._makeRepository);

  @override
  Future<DataState<List<MakeEntity>>> call({void params}) {
    return _makeRepository.getMakes();
  }

}
