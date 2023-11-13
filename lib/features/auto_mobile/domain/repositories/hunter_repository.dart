import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/hunter.dart';

/// Domain -> Repository <- Data
abstract class HunterRepository {
  /// Remote API Methods Calls ///

  Future<DataState<List<HunterEntity>>> getHunters();

  Future<DataState<List<HunterEntity>>> getHunterPartsByHunterNo(String hunterNo);

  Future<DataState<List<HunterEntity>>> getHunterPartsByPartNo(String partNo);
}
