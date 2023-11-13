import 'package:automasters/features/auto_mobile/domain/entities/vehicle.dart';

// @Entity(tableName: "vehicle_tbl", primaryKeys: ["id"])
class VehicleModel extends VehicleEntity {
  const VehicleModel({
    int? id,
    String? vin,
    String? vehicleCode,
    String? vfam,
    String? model,
    String? make,
    String? fuelType,
    String? year,
    String? category,
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
  }) : super(
          id: id,
          vin: vin,
    vehicleCode: vehicleCode,
          vfam: vfam,
          model: model,
          make: make,
          fuelType: fuelType,
          year: year,
          category: category,
          // vehicleImages: vehicleImages,

          // required len,
          // required modelRef,
          // required makeRef,
          // required body,
          // required engine,
          // required madeIn,
          // required capacity,
          // required yearTo,
          // required yearFrom,
          // required weight,
          // required seats,
          // required doors,
          // required source,
        );

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

}
