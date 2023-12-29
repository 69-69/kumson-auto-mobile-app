import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class HunterState<T> extends Equatable {
  final T? hunter;
  final DioException? error;

  const HunterState({this.hunter, this.error});

  @override
  List<Object?> get props => [hunter, error];
}

class HunterLoading extends HunterState {
  const HunterLoading();
}

/// Hunters Done
class HunterDone<T> extends HunterState<T> {
  const HunterDone(T hunters) : super(hunter: hunters);
}

class HunterError extends HunterState {
  const HunterError(DioException error) : super(error: error);
}
