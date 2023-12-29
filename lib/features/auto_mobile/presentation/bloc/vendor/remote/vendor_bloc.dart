import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/vendor.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Ref: https://github.com/mahdinazmi/Flutter-News-App-Clean-Architecture/blob/main/lib/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart

/// Vendors Bloc
class VendorsBloc extends Bloc<VendorEvent, VendorState> {
  final GetVendorsUseCase _getVendorsUseCase;

  VendorsBloc(this._getVendorsUseCase) : super(const VendorLoading()) {
    on<GetVendors>(_onGetVendors,
      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  void _onGetVendors(GetVendors event, Emitter<VendorState> emit) async {
    final dataState = await _getVendorsUseCase.call();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VendorDone<List<VendorEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(VendorError(dataState.error!));
    }
  }
}

/// VendorById Bloc
class VendorByIdBloc extends Bloc<VendorEvent, VendorState> {
  final GetVendorByIdUseCase _getVendorByIdUseCase;

  VendorByIdBloc(this._getVendorByIdUseCase) : super(const VendorLoading()) {
    on<GetVendorById>(
      _onGetVendorById,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetVendorById(GetVendorById event, Emitter<VendorState> emit) async {
    try {
    final dataState = await _getVendorByIdUseCase.call(params: event.id);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VendorDone<VendorEntity>(dataState.data!));
    }

    } on DataFailed catch (e) {
      emit(VendorError(e.error!));
    } catch (_) {}
  }
}

/// VendorPartsByBrandPartNo Bloc
class VendorPartsByBrandPartNoBloc extends Bloc<VendorEvent, VendorState> {
  final GetVendorPartsByBrandPartNoUseCase _getVendorPartsByBrandPartNoUseCase;

  VendorPartsByBrandPartNoBloc(this._getVendorPartsByBrandPartNoUseCase)
      : super(const VendorLoading()) {
    on<GetVendorPartsByBrandPartNo>(
      _onGetVendorPartsByBrandPartNo,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetVendorPartsByBrandPartNo(
      GetVendorPartsByBrandPartNo event, Emitter<VendorState> emit,) async {
    try {
    VendorEntity params =
        VendorEntity(brand: event.brand, partNo: event.partNo);
    final dataState = await _getVendorPartsByBrandPartNoUseCase.call(
      params: params,
    );

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(VendorDone<List<VendorEntity>>(dataState.data!));
    }

    } on DataFailed catch (e) {
      emit(VendorError(e.error!));
    } catch (_) {}
  }

  /// For Debugging Purpose Only: observe all state changes [onChange]
  @override
  void onChange(Change<VendorState> change) {
    super.onChange(change);
    debugPrint("Vendor-Bloc: ${change.currentState}\n\n");
  }

  /// For Debugging Purpose Only:
  /// current state, the event, and the next state [onTransition]
  @override
  void onTransition(Transition<VendorEvent, VendorState> transition) {
    super.onTransition(transition);
    debugPrint("Vendor-Bloc: $transition\n\n");
  }
}
