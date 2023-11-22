import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/features/auto_mobile/domain/entities/make.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_make.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_state.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Makes Bloc
class MakesBloc extends Bloc<MakesEvent, MakesState> {
  final GetMakesUseCase _getVehicleUseCase;

  MakesBloc(this._getVehicleUseCase) : super(const MakesLoading()) {
    on<GetMakesEvent>(onGetMakes);
  }

  void onGetMakes(GetMakesEvent event, Emitter<MakesState> emit) async {
    final dataState = await _getVehicleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MakesDone<List<MakeEntity>>(dataState.data!));
    }

    if (dataState is DataFailed) {
      // debugPrint("DataFailed-> ${dataState.error!.message}");
      // pass the data
      emit(MakesError(dataState.error!));
    }
  }
}
