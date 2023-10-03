class Model {
  final int id;
  final String model;
  final String modelRef;
  final String makeRef;
  final String note;
  final String personnel;

  // final Map<String, dynamic> images;

  Model({
    this.id = 0,
    this.model = "",
    this.modelRef = "",
    this.makeRef = "",
    this.note = "",
    this.personnel = "",
    // required this.images
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      model: json['model'],
      modelRef: json['modelRef'],
      makeRef: json['makeRef'],
      note: json['note'],
      personnel: json['personnel'],
      // images: json['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  static Map<String, dynamic> toMap(Model item) => {
        "id": item.id,
        "model": item.model,
        "modelRef": item.modelRef,
        "makeRef": item.makeRef,
        "note": item.note,
        "personnel": item.personnel,
      };

  /// Update Parts Object/Model property[copy]
  Model copy({
    int? id,
    String? model,
    String? modelRef,
    String? makeRef,
    String? note,
    String? personnel,
    // Map<String, dynamic>? images,
  }) =>
      Model(
        id: id ?? 0,
        model: model ?? "",
        modelRef: modelRef ?? "",
        makeRef: makeRef ?? "",
        note: note ?? "",
        personnel: personnel ?? "",
        // images: images ?? {},
      );
}
