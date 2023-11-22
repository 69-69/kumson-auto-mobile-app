import '../../domain/entities/hunter.dart';

class HunterModel extends HunterEntity {
  const HunterModel({
    super.id,
    super.product,
    super.partNo,
    super.brand,
    super.brandCode,
    super.productCode,
    super.productStatus,
    super.hunter,
    super.sku,
    super.universalPartNo,
    super.manufacturerNo,
    super.manufacturerType,
    super.sources,
    super.note,
    super.personnel,

    // required this.images
  });

  HunterModel copyWith({
    int? id,
    String? product,
    String? partNo,
    String? brand,
    String? brandCode,
    String? productCode,
    String? productStatus,
    String? hunter,
    String? sku,
    String? universalPartNo,
    String? manufacturerNo,
    String? manufacturerType,
    String? sources,
    String? note,
    String? personnel,
  }) {
    return HunterModel(
      id: id ?? this.id,
      product: product ?? this.product,
      partNo: partNo ?? this.partNo,
      brand: brand ?? this.brand,
      brandCode: brandCode ?? this.brandCode,
      productCode: productCode ?? this.productCode,
      productStatus: productStatus ?? this.productStatus,
      hunter: hunter ?? this.hunter,
      sku: sku ?? this.sku,
      universalPartNo: universalPartNo ?? this.universalPartNo,
      manufacturerNo: manufacturerNo ?? this.manufacturerNo,
      manufacturerType: manufacturerType ?? this.manufacturerType,
      sources: sources ?? this.sources,
      note: note ?? this.note,
      personnel: personnel ?? this.personnel,
    );
  }

  /// Empty hunter which has no data.
  static const empty = HunterModel(product: '');

  /// Convenience getter to determine whether the current hunter request is empty.
  @override
  bool get isEmpty => this == HunterModel.empty;

  /// Convenience getter to determine whether the current hunter request is not empty.
  @override
  bool get isNotEmpty => this != HunterModel.empty;

  factory HunterModel.fromJson(Map<String, dynamic> map) {
    return HunterModel(
      id: map["id"],
      product: map["product"],
      partNo: map["partNo"],
      brand: map["brand"],
      brandCode: map["brandCode"],
      productCode: map["productCode"],
      productStatus: map["productStatus"],
      hunter: map["hunter"],
      sku: map["sku"],
      universalPartNo: map["universalPartNo"],
      manufacturerNo: map["manufacturerNo"],
      manufacturerType: map["manufacturerType"],
      sources: map["sources"],
      note: map["note"],
      personnel: map["personnel"],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory HunterModel.fromEntity(HunterEntity entity) => HunterModel(
        id: entity.id,
        product: entity.product,
        partNo: entity.partNo,
        brand: entity.brand,
        brandCode: entity.brandCode,
        productCode: entity.productCode,
        productStatus: entity.productStatus,
        hunter: entity.hunter,
        sku: entity.sku,
        universalPartNo: entity.universalPartNo,
        manufacturerNo: entity.manufacturerNo,
        manufacturerType: entity.manufacturerType,
        sources: entity.sources,
        note: entity.note,
        personnel: entity.personnel,
      );

  static List<HunterModel> fromJsonList(List data) =>
      data.map((dynamic i) => HunterModel.fromJson(i as Map<String, dynamic>))
          .toList();
}
