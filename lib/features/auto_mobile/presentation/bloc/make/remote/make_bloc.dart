import 'package:automasters/core/resources/data_state.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/domain/entities/make.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_make.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_state.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Makes Bloc
class MakesBloc extends Bloc<MakeEvent, MakeState> {
  final GetMakesUseCase _getVehicleUseCase;

  MakesBloc(this._getVehicleUseCase) : super(const MakeLoading()) {
    on<GetMakesEvent>(_onGetMakes,
      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  Future<void> _onGetMakes(GetMakesEvent event, Emitter<MakeState> emit,) async {
    try {
    final dataState = await _getVehicleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MakeDone<List<MakeEntity>>(dataState.data!));
    }

    } on DataFailed catch (e) {
      emit(MakeError(e.error!));
    } catch (_) {}
  }
}
