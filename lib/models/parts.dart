class PartModel {
  final int id;
  final String vin;
  final String vfam;
  final String part;
  final String partCode;
  final String model;
  final String modelCode;
  final String make;
  final String makeCode;
  final String description;
  final String engine;
  final String engineType;
  final String hunter;
  final String note;
  final String personnel;

  // final Map<String, dynamic> images;

  PartModel({
    this.id = 0,
    this.vin = "",
    this.vfam = "",
    this.part = "",
    this.partCode = "",
    this.model = "",
    this.modelCode = "",
    this.make = "",
    this.makeCode = "",
    this.description = "",
    this.engine="",
    this.engineType="",
    this.hunter = "",
    this.note = "",
    this.personnel = "",
    // required this.images
  });

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return PartModel(
      id: json['id'],
      vin: json['vin'],
      vfam: json['vfam'],
      part: json['part'],
      partCode: json['partCode'],
      model: json['model'],
      modelCode: json['modelCode'],
      make: json['make'],
      makeCode: json['makeCode'],
      description: json['description'],
      engine: json['engine'],
      engineType: json['engineType'],
      hunter: json['hunter'],
      note: json['note'],
      personnel: json['personnel'],
      // images: json['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  static Map<String, dynamic> toMap(PartModel item) => {
        "id": item.id,
        "vin": item.vin,
        "vfam": item.vfam,
        "part": item.part,
        "partCode": item.partCode,
        "model": item.model,
        "modelCode": item.modelCode,
        "make": item.make,
        "makeCode": item.makeCode,
        "description": item.description,
        "engine": item.engine,
        "engineType": item.engineType,
        "hunter": item.hunter,
        "note": item.note,
        "personnel": item.personnel,
      };

  /// Update Parts Object/Model property[copy]
  PartModel copy({
    int? id,
    String? vin,
    String? vfam,
    String? part,
    String? model,
    String? make,
    String? makeCode,
    String? description,
    String? engine,
    String? engineType,
    String? hunter,
    String? note,
    String? personnel,
    // Map<String, dynamic>? images,
  }) =>
      PartModel(
        id: id ?? 0,
        vin: vin ?? "",
        vfam: vfam ?? "",
        model: model ?? "",
        make: make ?? "",
        makeCode: makeCode ?? "",
        part: part ?? "",
        description: description ?? "",
        engine: engine ?? "",
        engineType: engineType ?? "",
        hunter: hunter ?? "",
        note: note ?? "",
        personnel: personnel ?? "",
        // images: images ?? {},
      );
}
