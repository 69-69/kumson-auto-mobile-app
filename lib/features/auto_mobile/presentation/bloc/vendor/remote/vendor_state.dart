import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VendorsState<T> extends Equatable {
  final T? vendor;
  final DioException? error;

  const VendorsState({this.vendor, this.error});

  @override
  List<Object?> get props => [vendor, error];
}

class VendorsLoading extends VendorsState {
  const VendorsLoading();
}

/// Vendors Done
class VendorsDone<T> extends VendorsState<T> {
  const VendorsDone(T vendors) : super(vendor: vendors);
}

class VendorsError extends VendorsState {
  const VendorsError(DioException error) : super(error: error);
}
