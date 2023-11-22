import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vendor.dart';

/// Domain -> Repository <- Data
abstract class VendorRepository {
  /// Remote API Methods Calls ///

  Future<DataState<List<VendorEntity>>> getVendors();

  Future<DataState<VendorEntity>> getVendorById(int id);

  Future<DataState<List<VendorEntity>>> getVendorPartsByBrandPartNo(
    String brand,
    String partNo,
  );
}
