class VehicleModel {
  final int id;
  final String vin;
  final String vfam;

  // final int len;
  final String model;

  // final String modelRef;
  final String make;

  // final String makeRef;
  // final String body;
  // final String engine;
  // final String madeIn;
  final String fuelType;

  // final int capacity;
  final String year;

  // final String yearTo;
  // final String yearFrom;
  // final int weight;
  final String category;

  // final int seats;
  // final int doors;
  // final String source;
  final Map<String, dynamic>? images;

  VehicleModel({
    this.id = 0,
    this.vin = "",
    this.vfam = "",
    // required this.len,
    this.model = "",
    // required this.modelRef,
    this.make = "",
    // required this.makeRef,
    // required this.body,
    // required this.engine,
    // required this.madeIn,
    this.fuelType = "",
    // required this.capacity,
    this.year = "",
    // required this.yearTo,
    // required this.yearFrom,
    // required this.weight,
    this.category = "",
    // required this.seats,
    // required this.doors,
    // required this.source,
    this.images,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      vin: json['vin'],
      vfam: json['vfam'],
      // len: json['len'],
      model: json['model'],
      // modelRef: json['modeRef'],
      make: json['make'],
      // makeRef: json['makeRef'],
      // body: json['body'],
      // engine: json['engine'],
      // madeIn: json['madeIn'],
      fuelType: json['fuelType'],
      // capacity: json['capacity'],
      year: json['year'],
      // yearTo: json['yearTo'],
      // yearFrom: json['yearFrom'],
      // weight: json['weight'],
      category: json['category'],
      // seats: json['seats'],
      // doors: json['doors'],
      // source: json['source'],
      images: json['vehicleImages'],
    );
  }

  /// Update Vehicle Object/Model property[copy]
  VehicleModel copy({
    int? id,
    String? vin,
    String? vfam,
    String? model,
    String? make,
    String? year,
    String? category,
    String? fuelType,
    Map<String, dynamic>? images,
  }) =>
      VehicleModel(
        id: id ?? 0,
        vin: vin ?? "",
        vfam: vfam ?? "",
        model: model ?? "",
        make: make ?? "",
        year: year ?? "",
        fuelType: fuelType ?? "",
        category: category ?? "",
        images: images ?? {},
      );
}
