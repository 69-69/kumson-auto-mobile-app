import 'package:equatable/equatable.dart';

class HunterEntity extends Equatable {
  final int? id;
  final String? product;
  final String? partNo;
  final String? brand;
  final String? brandCode;
  final String? productCode;
  final String? productStatus;
  final String? hunter;
  final String? sku;
  final String? universalPartNo;
  final String? manufacturerNo;
  final String? manufacturerType;
  final String? sources;
  final String? note;
  final String? personnel;

  // final Map<String, dynamic> images;

  const HunterEntity({
    this.id,
    this.product,
    this.partNo,
    this.brand,
    this.brandCode,
    this.productCode,
    this.productStatus,
    this.hunter,
    this.sku,
    this.universalPartNo,
    this.manufacturerNo,
    this.manufacturerType,
    this.sources,
    this.note,
    this.personnel,

    // required this.images
  });

  /// Empty hunter which has no data.
  // static const empty = HunterEntity(product: '');

  /// Convenience getter to determine whether the current hunter request is empty.
  // bool get isEmpty => this == HunterEntity.empty;

  /// Convenience getter to determine whether the current hunter request is not empty.
  // bool get isNotEmpty => this != HunterEntity.empty;

  @override
  List<Object?> get props => [
        id,
        product,
        partNo,
        brand,
        brandCode,
        productCode,
        productStatus,
        hunter,
        sku,
        universalPartNo,
        manufacturerNo,
        manufacturerType,
        sources,
        note,
        personnel,
      ];
}
