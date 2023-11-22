import '../../domain/entities/parts.dart';

class PartModel extends PartEntity {
  const PartModel({
    super.id,
    super.vin,
    super.vfam,
    super.part,
    super.partCode,
    super.model,
    super.modelCode,
    super.make,
    super.makeCode,
    super.description,
    super.engine,
    super.engineType,
    super.hunter,
    super.note,
    super.personnel,

    // required this.images
  });

  PartModel copyWith({
    int? id,
    String? vin,
    String? vfam,
    String? part,
    String? partCode,
    String? model,
    String? modelCode,
    String? make,
    String? makeCode,
    String? description,
    String? engine,
    String? engineType,
    String? hunter,
    String? note,
    String? personnel,
  }) {
    return PartModel(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      vfam: vfam ?? this.vfam,
      part: part ?? this.part,
      partCode: partCode ?? this.partCode,
      model: model ?? this.model,
      modelCode: modelCode ?? this.modelCode,
      make: make ?? this.make,
      makeCode: makeCode ?? this.makeCode,
      description: description ?? this.description,
      engine: engine ?? this.engine,
      engineType: engineType ?? this.engineType,
      hunter: hunter ?? this.hunter,
      note: note ?? this.note,
      personnel: personnel ?? this.personnel,
    );
  }

  /// Empty Part which has no data.
  static const empty = PartModel(part: '');

  /// Convenience getter to determine whether the current Part request is empty.
  @override
  bool get isEmpty => this == PartModel.empty;

  /// Convenience getter to determine whether the current Part request is not empty.
  @override
  bool get isNotEmpty => this != PartModel.empty;

  factory PartModel.fromJson(Map<String, dynamic> map) {
    return PartModel(
      id: map["id"],
      vin: map["vin"],
      vfam: map["vfam"],
      part: map["part"],
      partCode: map["partCode"],
      model: map["model"],
      modelCode: map["modelCode"],
      make: map["make"],
      makeCode: map["makeCode"],
      description: map["description"],
      engine: map["engine"],
      engineType: map["engineType"],
      hunter: map["hunter"],
      note: map["note"],
      personnel: map["personnel"],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory PartModel.fromEntity(PartEntity entity) => PartModel(
        id: entity.id,
        vin: entity.vin,
        vfam: entity.vfam,
        part: entity.part,
        partCode: entity.partCode,
        model: entity.model,
        modelCode: entity.modelCode,
        make: entity.make,
        makeCode: entity.makeCode,
        description: entity.description,
        engine: entity.engine,
        engineType: entity.engineType,
        hunter: entity.hunter,
        note: entity.note,
        personnel: entity.personnel,
      );

  static List<PartModel> fromJsonList(List data) =>
      data.map((dynamic i) => PartModel.fromJson(i as Map<String, dynamic>))
          .toList();
}
