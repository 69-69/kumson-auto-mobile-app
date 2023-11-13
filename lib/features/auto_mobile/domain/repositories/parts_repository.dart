import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';

/// Domain -> Repository <- Data
abstract class PartsRepository {
  /// Remote API Methods Calls ///

  // Get All Parts
  Future<DataState<List<PartEntity>>> getParts();

  // Get Parts by hunter-no or personnel
  Future<DataState<PartEntity>> getPartByHunterNo(String hunterNo);

  // Get Parts by vfam
  Future<DataState<List<PartEntity>>> getPartsByVFam(String vfam);

  // Get Parts by Make & Model
  Future<DataState<List<PartEntity>>> getPartsByVMakeModel(
    String make,
    String model,
  );

  // Get Parts Years By Make & Model
  Future<DataState<List<int>>> getPartsYearsByMakeModel(
    String make,
    String model,
  );
}
