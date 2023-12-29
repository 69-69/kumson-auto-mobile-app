import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class VendorState<T> extends Equatable {
  final T? vendor;
  final DioException? error;

  const VendorState({this.vendor, this.error});

  @override
  List<Object?> get props => [vendor, error];
}

class VendorLoading extends VendorState {
  const VendorLoading();
}

/// Vendors Done
class VendorDone<T> extends VendorState<T> {
  const VendorDone(T vendors) : super(vendor: vendors);
}

class VendorError extends VendorState {
  const VendorError(DioException error) : super(error: error);
}
