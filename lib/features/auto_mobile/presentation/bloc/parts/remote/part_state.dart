import 'package:automasters/features/auto_mobile/domain/entities/parts.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class PartState<T> extends Equatable {
  // final List<T>? parts;
  final T? part;
  final DioException? error;

  const PartState({/*this.parts,*/ this.part, this.error});

  @override
  List<Object?> get props => [/*parts ?? [],*/ part, error];
}

class PartLoading extends PartState<PartEntity> {
  const PartLoading();
}

/// Many Parts Done:
/// (This is Generic Type <T>...always specify TYPE when calling 'PartsDone')
class PartDone<T> extends PartState<T> {
  const PartDone(T parts) : super(part: parts);
}

/// One Part Done
/*class PartByDone extends PartsState<PartEntity> {
  const PartByDone(PartEntity part) : super(part: part);
}*/

class PartError extends PartState<PartEntity> {
  const PartError(DioException error) : super(error: error);
}
