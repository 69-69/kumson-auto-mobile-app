import '../../domain/entities/hunter.dart';

class HunterModel extends HunterEntity {
  const HunterModel({
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

    // required this.images
  }) : super(
          id: id,
          product: product,
          partNo: partNo,
          brand: brand,
          brandCode: brandCode,
          productCode: productCode,
          productStatus: productStatus,
          hunter: hunter,
          sku: sku,
          universalPartNo: universalPartNo,
          manufacturerNo: manufacturerNo,
          manufacturerType: manufacturerType,
          sources: sources,
          note: note,
          personnel: personnel,
        );

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
