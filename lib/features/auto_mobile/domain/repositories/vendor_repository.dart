import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';

/// Domain -> Repository <- Data
abstract class VendorRepository {
  /// Remote API Methods Calls ///

  Future<DataState<List<VendorModel>>> getVendors();

  Future<DataState<VendorModel>> getVendorById(int id);

  Future<DataState<List<VendorModel>>> getVendorPartsByBrandPartNo(
    String brand,
    String partNo,
  );
}
