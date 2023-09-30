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
      };

  /// Update Parts Object/Model property[copy]
  PartModel copy({
    int? id,
    String? vin,
    String? vfam,
    String? part,
    String? model,
    String? make,
    String? description,
    // Map<String, dynamic>? images,
  }) =>
      PartModel(
        id: id ?? 0,
        vin: vin ?? "",
        vfam: vfam ?? "",
        model: model ?? "",
        make: make ?? "",
        part: part ?? "",
        description: description ?? "",
        // images: images ?? {},
      );
}
