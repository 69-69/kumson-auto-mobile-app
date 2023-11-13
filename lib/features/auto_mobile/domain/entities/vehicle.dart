import 'package:equatable/equatable.dart';

/// Domain -> Entity
class VehicleEntity extends Equatable {
  final int? id;
  final String? vin;
  final String? vehicleCode;
  final String? vfam;
  final String? model;
  final String? make;
  final String? fuelType;
  final String? year;
  final String? category;

  // final Map<String, dynamic>? vehicleImages;

  // final int len;
  // final String modelRef;
  // final String makeRef;
  // final String body;
  // final String engine;
  // final String madeIn;
  // final int capacity;
  // final String yearTo;
  // final String yearFrom;
  // final int weight;
  // final int seats;
  // final int doors;
  // final String source;

  const VehicleEntity({
    this.id,
    this.vin,
    this.vehicleCode,
    this.vfam,
    this.model,
    this.make,
    this.fuelType,
    this.year,
    this.category,
    // this.vehicleImages,
    // required this.len,
    // required this.modelRef,
    // required this.makeRef,
    // required this.body,
    // required this.engine,
    // required this.madeIn,
    // required this.capacity,
    // required this.yearTo,
    // required this.yearFrom,
    // required this.weight,
    // required this.seats,
    // required this.doors,
    // required this.source,
  });

  @override
  List<Object?> get props => [
        id,
        vin,
        vehicleCode,
        vfam,
        model,
        make,
        fuelType,
        year,
        category,
        // vehicleImages,
      ];
}
