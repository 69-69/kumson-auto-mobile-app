class PartModel {
  final int id;
  final String vin;
  final String vfam;
  final String part;
  final String partRef;
  final String model;
  final String modelRef;
  final String make;
  final String makeRef;
  final String description;
  final String hunter;
  final String note;
  final String personnel;

  // final Map<String, dynamic> images;

  PartModel({
    this.id = 0,
    this.vin = "",
    this.vfam = "",
    this.part = "",
    this.partRef = "",
    this.model = "",
    this.modelRef = "",
    this.make = "",
    this.makeRef = "",
    this.description = "",
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
      partRef: json['partRef'],
      model: json['model'],
      modelRef: json['modelRef'],
      make: json['make'],
      makeRef: json['makeRef'],
      description: json['description'],
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
        "partRef": item.partRef,
        "model": item.model,
        "modelRef": item.modelRef,
        "make": item.make,
        "makeRef": item.makeRef,
        "description": item.description,
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
    String? makeRef,
    String? description,
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
        makeRef: makeRef ?? "",
        part: part ?? "",
        description: description ?? "",
        hunter: hunter ?? "",
        note: note ?? "",
        personnel: personnel ?? "",
        // images: images ?? {},
      );
}
