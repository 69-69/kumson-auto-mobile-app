import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class PartsState<T> extends Equatable {
  final List<T>? parts;
  final T? part;
  final DioException? error;

  const PartsState({this.parts, this.part, this.error});

  @override
  List<Object> get props => [parts ?? [], part ?? [], error ?? []];
}

class PartsLoading extends PartsState<PartEntity> {
  const PartsLoading();
}

/// Many Parts Done:
/// (This is Generic Type <T>...always specify TYPE when calling 'PartsDone')
class PartsDone<T> extends PartsState<T> {
  const PartsDone(List<T> parts) : super(parts: parts);
}

/// One Part Done
class PartByDone extends PartsState<PartEntity> {
  const PartByDone(PartEntity part) : super(part: part);
}

class PartsError extends PartsState<PartEntity> {
  const PartsError(DioException error) : super(error: error);
}
