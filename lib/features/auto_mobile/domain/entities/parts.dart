import 'package:equatable/equatable.dart';

class PartEntity extends Equatable {
  final int ? id;
  final String ? vin;
  final String ? vfam;
  final String ? part;
  final String ? partCode;
  final String ? model;
  final String ? modelCode;
  final String ? make;
  final String ? makeCode;
  final String ? description;
  final String ? engine;
  final String ? engineType;
  final String ? hunter;
  final String ? note;
  final String ? personnel;

  // final Map<String, dynamic> images;

  const PartEntity({
    this.id,
    this.vin,
    this.vfam,
    this.part,
    this.partCode,
    this.model,
    this.modelCode,
    this.make,
    this.makeCode,
    this.description,
    this.engine,
    this.engineType,
    this.hunter,
    this.note,
    this.personnel,

    // required this.images
  });

  /// Empty Part which has no data.
  static const empty = PartEntity(part: '');

  /// Convenience getter to determine whether the current Part request is empty.
  bool get isEmpty => this == PartEntity.empty;

  /// Convenience getter to determine whether the current Part request is not empty.
  bool get isNotEmpty => this != PartEntity.empty;

  @override
  List<Object?> get props => [
    id,
    vin,
    vfam,
    part,
    partCode,
    model,
    modelCode,
    make,
    makeCode,
    description,
    engine,
    engineType,
    hunter,
    note,
    personnel,
  ];
}
