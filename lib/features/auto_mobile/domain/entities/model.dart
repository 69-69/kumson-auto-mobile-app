import 'package:equatable/equatable.dart';

class ModelEntity extends Equatable {
  final int? id;
  final String? model;
  final String? modelRef;
  final String? makeRef;
  final String? note;
  final String? personnel;

  // final Map<String, dynamic> images;

  const ModelEntity({
    this.id,
    this.model,
    this.modelRef,
    this.makeRef,
    this.note,
    this.personnel,

    // required this.images
  });

  /// Empty Model which has no data.
  static const empty = ModelEntity(model: '');

  /// Convenience getter to determine whether the current Model request is empty.
  bool get isEmpty => this == ModelEntity.empty;

  /// Convenience getter to determine whether the current Model request is not empty.
  bool get isNotEmpty => this != ModelEntity.empty;

  @override
  List<Object?> get props => [
    id,
    model,
    modelRef,
    makeRef,
    note,
    personnel,
  ];
}
