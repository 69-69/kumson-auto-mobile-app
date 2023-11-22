import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class HuntersState<T> extends Equatable {
  // final List<HunterEntity>? hunters;
  // final HunterEntity? hunter;
  final T? hunter;
  final DioException? error;

  const HuntersState({/*this.hunters,*/ this.hunter, this.error});

  @override
  List<Object?> get props => [/*hunters ?? [],*/ hunter, error];
}

class HuntersLoading extends HuntersState {
  const HuntersLoading();
}

/// Hunters Done
class HuntersDone<T> extends HuntersState<T> {
  const HuntersDone(T hunters) : super(hunter: hunters);
}

/// HunterBy Done
/*class HunterByDone extends HuntersState {
  const HunterByDone(HunterEntity hunter) : super(hunter: hunter);
}*/

class HuntersError extends HuntersState {
  const HuntersError(DioException error) : super(error: error);
}
