
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';

class Model extends ModelEntity {
  const Model({
    int? id,
    String? model,
    String? modelRef,
    String? makeRef,
    String? note,
    String? personnel,

    // required this.images
  }) : super(
    id: id,
    model: model,
    modelRef: modelRef,
    makeRef: makeRef,
    note: note,
    personnel: personnel,
  );

  Model copyWith({
    int? id,
    String? model,
    String? modelRef,
    String? makeRef,
    String? note,
    String? personnel,
  }) {
    return Model(
      model: model ?? this.model,
      modelRef: modelRef ?? this.modelRef,
      makeRef: makeRef ?? this.makeRef,
      note: note ?? this.note,
      personnel: personnel ?? this.personnel,
    );
  }

  factory Model.fromJson(Map<String, dynamic> map) {
    return Model(
      id: map['id'],
      model: map['model'],
      modelRef: map['modelRef'],
      makeRef: map['makeRef'],
      note: map['note'],
      personnel: map['personnel'],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory Model.fromEntity(ModelEntity entity) => Model(
    id: entity.id,
    model: entity.model,
    modelRef: entity.modelRef,
    makeRef: entity.makeRef,
    note: entity.note,
    personnel: entity.personnel,
  );

  static List<Model> fromJsonList(List data) =>
      data.map((dynamic i) => Model.fromJson(i as Map<String, dynamic>))
          .toList();

  ///custom comparing function to check if two models are equal
  bool isEqual(Model model) {
    return id == model.id;
  }

  @override
  String toString() {
    return model!.replaceFirst(model![0], model![0].toUpperCase());
  }
}
