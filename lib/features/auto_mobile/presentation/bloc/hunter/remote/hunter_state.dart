import 'package:automasters/features/auto_mobile/domain/entities/hunter.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class HuntersState extends Equatable {
  final List<HunterEntity>? hunters;
  final HunterEntity? hunter;
  final DioException? error;

  const HuntersState({this.hunters, this.hunter, this.error});

  @override
  List<Object> get props => [hunters ?? [], hunter ?? [], error ?? []];
}

class HuntersLoading extends HuntersState {
  const HuntersLoading();
}

/// Hunters Done
class HuntersDone extends HuntersState {
  const HuntersDone(List<HunterEntity> hunters) : super(hunters: hunters);
}

/// HunterBy Done
class HunterByDone extends HuntersState {
  const HunterByDone(HunterEntity hunter) : super(hunter: hunter);
}

class HuntersError extends HuntersState {
  const HuntersError(DioException error) : super(error: error);
}
