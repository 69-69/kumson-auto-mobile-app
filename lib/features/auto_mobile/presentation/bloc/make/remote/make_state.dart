import 'package:automasters/features/auto_mobile/domain/entities/make.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class MakesState extends Equatable {
  final List<MakeEntity>? makes;
  final DioException? error;

  const MakesState({this.makes, this.error});

  @override
  List<Object> get props => [makes ?? [], error ?? []];
}

class MakesLoading extends MakesState {
  const MakesLoading();
}

class MakesDone extends MakesState {
  const MakesDone(List<MakeEntity> makes) : super(makes: makes);
}

class MakesError extends MakesState {
  const MakesError(DioException error) : super(error: error);
}
