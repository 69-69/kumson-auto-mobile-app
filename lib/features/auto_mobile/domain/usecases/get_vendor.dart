import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/usecases/usecase.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vendor.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vendor_repository.dart';

class GetVendorsUseCase
    implements UseCase<DataState<List<VendorEntity>>, void> {
  final VendorRepository _vendorRepository;

  GetVendorsUseCase(this._vendorRepository);

  @override
  Future<DataState<List<VendorEntity>>> call({void params}) {
    return _vendorRepository.getVendors();
  }
}

class GetVendorByIdUseCase implements UseCase<DataState<VendorEntity>, int> {
  final VendorRepository _vendorRepository;

  GetVendorByIdUseCase(this._vendorRepository);

  @override
  Future<DataState<VendorEntity>> call({int? params}) {
    return _vendorRepository.getVendorById(params ?? 0);
  }
}

class GetVendorPartsByBrandPartNoUseCase
    implements UseCase<DataState<List<VendorEntity>>, VendorEntity> {
  final VendorRepository _vendorRepository;

  GetVendorPartsByBrandPartNoUseCase(this._vendorRepository);

  @override
  Future<DataState<List<VendorEntity>>> call({VendorEntity? params}) {
    return _vendorRepository.getVendorPartsByBrandPartNo(
      params!.brand!,
      params.partNo!,
    );
  }
}
