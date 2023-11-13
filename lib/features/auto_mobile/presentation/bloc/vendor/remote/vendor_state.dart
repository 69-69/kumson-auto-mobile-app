import 'package:automasters/features/auto_mobile/domain/entities/vendor.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VendorsState<VendorEntity> extends Equatable {
  final List<VendorEntity>? vendors;
  final VendorEntity? vendor;
  final DioException? error;

  const VendorsState({this.vendors, this.vendor, this.error});

  @override
  List<Object> get props => [vendors ?? [], vendor ?? [], error ?? []];
}

class VendorsLoading extends VendorsState {
  const VendorsLoading();
}

/// Vendors Done
class VendorsDone extends VendorsState {
  const VendorsDone(List<VendorEntity> vendors) : super(vendors: vendors);
}

/// VendorByIdDone Done
class VendorByIdDone extends VendorsState {
  const VendorByIdDone(VendorEntity vendor) : super(vendor: vendor);
}

class VendorsError extends VendorsState {
  const VendorsError(DioException error) : super(error: error);
}
