
import 'package:automasters/features/auto_mobile/domain/entities/model.dart';

class Model extends ModelEntity {
  const Model({
    super.id,
    super.model,
    super.modelRef,
    super.makeRef,
    super.note,
    super.personnel,

    // required this.images
  });

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

  /// Empty Model which has no data.
  static const empty = Model(model: '');

  /// Convenience getter to determine whether the current Model request is empty.
  @override
  bool get isEmpty => this == Model.empty;

  /// Convenience getter to determine whether the current Model request is not empty.
  @override
  bool get isNotEmpty => this != Model.empty;

  ///custom comparing function to check if two models are equal
  bool isEqual(Model model) {
    return id == model.id;
  }

  @override
  String toString() {
    return model!.replaceFirst(model![0], model![0].toUpperCase());
  }
}
