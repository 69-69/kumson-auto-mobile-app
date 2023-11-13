import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/make.dart';

/// Domain -> Repository <- Data
abstract class MakeRepository {

  /// Remote API Methods Calls ///

  Future<DataState<List<MakeEntity>>> getMakes();

}