import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class MakeState<T> extends Equatable {
  // final List<MakeEntity>? makes;
  final T? make;
  final DioException? error;

  const MakeState({this.make, this.error});

  @override
  List<Object?> get props => [make, error];
}

class MakeLoading extends MakeState {
  const MakeLoading();
}

class MakeDone<T> extends MakeState<T> {
  const MakeDone(T makes) : super(make: makes);
}

class MakeError extends MakeState {
  const MakeError(DioException error) : super(error: error);
}
