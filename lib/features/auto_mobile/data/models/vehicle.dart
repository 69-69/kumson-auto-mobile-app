import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';

// @Entity(tableName: "vehicle_tbl", primaryKeys: ["id"])
class VehicleModel extends VehicleEntity {
  const VehicleModel({
    super.id,
    super.vin,
    super.vehicleCode,
    super.vfam,
    super.model,
    super.make,
    super.fuelType,
    super.year,
    super.category,
    // List<String>? vehicleImages,

    // int len,
    // String modelRef,
    // String makeRef,
    // String body,
    // String engine,
    // String madeIn,
    // int capacity,
    // String yearTo,
    // String yearFrom,
    // int weight,
    // int seats,
    // int doors,
    // String source,
  });

  VehicleModel copyWith({
    int? id,
    String? vin,
    String? vehicleCode,
    String? vfam,
    String? model,
    String? make,
    String? fuelType,
    String? year,
    String? category,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      vehicleCode: vehicleCode ?? this.vehicleCode,
      vfam: vfam ?? this.vfam,
      model: model ?? this.model,
      make: make ?? this.make,
      fuelType: fuelType ?? this.fuelType,
      year: year ?? this.vfam,
      category: category ?? this.category,
    );
  }

  factory VehicleModel.fromJson(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] ?? "",
      vin: map['vin'] ?? "",
      vehicleCode: map['vehicleCode'] ?? "",
      vfam: map['vfam'] ?? "",
      model: map['model'] ?? "",
      make: map['make'] ?? "",
      fuelType: map['fuelType'] ?? "",
      year: map['year'] ?? "",
      category: map['category'] ?? "",
      // vehicleImages: List<String>.from(map['vehicleImages']),

      // len: json['len'],
      // modelRef: json['modeRef'],
      // makeRef: json['makeRef'],
      // body: json['body'],
      // engine: json['engine'],
      // madeIn: json['madeIn'],
      // capacity: json['capacity'],
      // yearTo: json['yearTo'],
      // yearFrom: json['yearFrom'],
      // weight: json['weight'],
      // seats: json['seats'],
      // doors: json['doors'],
      // source: json['source'],
    );
  }

  factory VehicleModel.fromEntity(VehicleEntity entity) => VehicleModel(
      id: entity.id,
      vin: entity.vin,
      vehicleCode: entity.vehicleCode,
      vfam: entity.vfam,
      model: entity.model,
      make: entity.make,
      fuelType: entity.fuelType,
      year: entity.year,
      category: entity.category,
      // vehicleImages: entity.vehicleImages,

      // len: json['len'],
      // modelRef: json['modeRef'],
      // makeRef: json['makeRef'],
      // body: json['body'],
      // engine: json['engine'],
      // madeIn: json['madeIn'],
      // capacity: json['capacity'],
      // yearTo: json['yearTo'],
      // yearFrom: json['yearFrom'],
      // weight: json['weight'],
      // seats: json['seats'],
      // doors: json['doors'],
      // source: json['source'],
    );

  static List<VehicleModel> fromJsonList(List data) =>
      data.map((dynamic i) => VehicleModel.fromJson(i as Map<String, dynamic>))
          .toList();

  /// Empty user which represents an unauthenticated user.
  static const empty = VehicleModel(vin: '');

  /// Convenience getter to determine whether the current vehicle request is empty.
  @override
  bool get isEmpty => this == VehicleModel.empty;

  /// Convenience getter to determine whether the current vehicle request is not empty.
  @override
  bool get isNotEmpty => this != VehicleModel.empty;
}
