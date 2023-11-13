import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';

/// Domain -> Repository <- Data
abstract class ModelRepository {

  /// Remote API Methods Calls ///

  // get All Models
  Future<DataState<List<ModelEntity>>> getModels();

  // Get Vehicle Model By Make Reference
  Future<DataState<List<ModelEntity>>> getModelsByMakeRef(String makeRef);

}
