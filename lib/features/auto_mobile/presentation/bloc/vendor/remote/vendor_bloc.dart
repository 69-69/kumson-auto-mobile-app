import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vendor.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Vendors Bloc
class VendorsBloc extends Bloc<VendorsEvent, VendorsState> {
  final GetVendorsUseCase _getVendorsUseCase;

  VendorsBloc(this._getVendorsUseCase) : super(const VendorsLoading()) {
    on<GetVendors>(
      onGetVendors,transformer: debounce(),);
  }

  void onGetVendors(GetVendors event, Emitter<VendorsState> emit) async {
    final dataState = await _getVendorsUseCase.call();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VendorsDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VendorsError(dataState.error!));
    }
  }
}

/// VendorById Bloc
class VendorByIdBloc extends Bloc<VendorsEvent, VendorsState> {
  final GetVendorByIdUseCase _getVendorByIdUseCase;

  VendorByIdBloc(this._getVendorByIdUseCase)
      : super(const VendorsLoading()) {
    on<GetVendorById>(
      onGetVendorById,transformer: debounce(),);
  }

  void onGetVendorById(GetVendorById event, Emitter<VendorsState> emit) async {
    final dataState = await _getVendorByIdUseCase.call(params: event.id);

    if (dataState is DataSuccess && dataState.data!.partNo!.isNotEmpty) {
      emit(VendorByIdDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the error
      emit(VendorsError(dataState.error!));
    }
  }
}

/// VendorPartsByBrandPartNo Bloc
class VendorPartsByBrandPartNoBloc extends Bloc<VendorsEvent, VendorsState> {
  final GetVendorPartsByBrandPartNoUseCase _getVendorPartsByBrandPartNoUseCase;

  VendorPartsByBrandPartNoBloc(this._getVendorPartsByBrandPartNoUseCase)
      : super(const VendorsLoading()) {
    on<GetVendorPartsByBrandPartNo>(
      onGetVendorPartsByBrandPartNo,transformer: debounce(),);
  }

  void onGetVendorPartsByBrandPartNo(
      GetVendorPartsByBrandPartNo event, Emitter<VendorsState> emit) async {
    VendorEntity params = VendorEntity(brand: event.brand, partNo: event.partNo);
    final dataState = await _getVendorPartsByBrandPartNoUseCase.call(
      params: params,
    );

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VendorsDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the error
      emit(VendorsError(dataState.error!));
    }
  }
}
