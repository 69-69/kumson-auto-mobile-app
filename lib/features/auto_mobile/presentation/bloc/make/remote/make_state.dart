import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class MakesState<T> extends Equatable {
  // final List<MakeEntity>? makes;
  final T? make;
  final DioException? error;

  const MakesState({this.make, this.error});

  @override
  List<Object?> get props => [make, error];
}

class MakesLoading extends MakesState {
  const MakesLoading();
}

class MakesDone<T> extends MakesState<T> {
  const MakesDone(T makes) : super(make: makes);
}

class MakesError extends MakesState {
  const MakesError(DioException error) : super(error: error);
}
