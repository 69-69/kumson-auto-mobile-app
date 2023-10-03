class MakeModel {
  final int id;
  final String make;
  final String makeRef;
  final String note;
  final String personnel;

  // final Map<String, dynamic> images;

  MakeModel({
    this.id = 0,
    this.make = "",
    this.makeRef = "",
    this.note = "",
    this.personnel = "",
    // required this.images
  });

  factory MakeModel.fromJson(Map<String, dynamic> json) {
    return MakeModel(
      id: json['id'],
      make: json['make'],
      makeRef: json['makeRef'],
      note: json['note'],
      personnel: json['personnel'],
      // images: json['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  static Map<String, dynamic> toMap(MakeModel item) => {
        "id": item.id,
        "make": item.make,
        "makeRef": item.makeRef,
        "note": item.note,
        "personnel": item.personnel,
      };

  /// Update Parts Object/Model property[copy]
  MakeModel copy({
    int? id,
    String? make,
    String? makeRef,
    String? note,
    String? personnel,
    // Map<String, dynamic>? images,
  }) =>
      MakeModel(
        id: id ?? 0,
        make: make ?? "",
        makeRef: makeRef ?? "",
        note: note ?? "",
        personnel: personnel ?? "",
        // images: images ?? {},
      );
}
