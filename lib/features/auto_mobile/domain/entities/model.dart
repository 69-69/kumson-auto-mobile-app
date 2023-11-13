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
