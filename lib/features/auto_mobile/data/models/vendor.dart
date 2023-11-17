import '../../domain/entities/vendor.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    int? id,
    String? partNo,
    String? brand,
    String? brandCode,
    String? brandType,
    String? vendor,
    String? vendorCode,
    int? currentPrice,
    String? stockStatus,
    String? productAge,
    String? opm,
    String? transactionDatetime,
    String? sources,
    String? note,
    String? personnel,

    // required this.images
  }) : super(
          id: id,
          partNo: partNo,
          brand: brand,
          brandCode: brandCode,
          brandType: brandType,
          vendor: vendor,
          vendorCode: vendorCode,
          currentPrice: currentPrice,
          stockStatus: stockStatus,
          productAge: productAge,
          opm: opm,
          transactionDatetime: transactionDatetime,
          sources: sources,
          note: note,
          personnel: personnel,
        );

  VendorModel copyWith({
    int? id,
    String? partNo,
    String? brand,
    String? brandCode,
    String? brandType,
    String? vendor,
    String? vendorCode,
    int? currentPrice,
    String? stockStatus,
    String? productAge,
    String? opm,
    String? transactionDatetime,
    String? sources,
    String? note,
    String? personnel,
  }) {
    return VendorModel(
      id: id ?? this.id,
      partNo: partNo ?? this.partNo,
      brand: brand ?? this.brand,
      brandCode: brandCode ?? this.brandCode,
      brandType: brandType ?? this.brandType,
      vendor: vendor ?? this.vendor,
      vendorCode: vendorCode ?? this.vendorCode,
      currentPrice: currentPrice ?? this.currentPrice,
      stockStatus: stockStatus ?? this.stockStatus,
      productAge: productAge ?? this.productAge,
      opm: opm ?? this.opm,
      transactionDatetime: transactionDatetime ?? this.transactionDatetime,
      sources: sources ?? this.sources,
      note: note ?? this.note,
      personnel: personnel ?? this.personnel,
    );
  }

  factory VendorModel.fromJson(Map<String, dynamic> map) {
    return VendorModel(
      id: map["id"],
      partNo: map["partNo"],
      brand: map["brand"],
      brandCode: map["brandCode"],
      brandType: map["brandType"],
      vendor: map["vendor"],
      vendorCode: map["vendorCode"],
      currentPrice: map["currentPrice"],
      stockStatus: map["stockStatus"],
      productAge: map["productAge"],
      opm: map["opm"],
      transactionDatetime: map["transactionDatetime"],
      sources: map["sources"],
      note: map["note"],
      personnel: map["personnel"],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory VendorModel.fromEntity(VendorEntity entity) => VendorModel(
        id: entity.id,
        partNo: entity.partNo,
        brand: entity.brand,
        brandCode: entity.brandCode,
        brandType: entity.brandType,
        vendor: entity.vendor,
        vendorCode: entity.vendorCode,
        currentPrice: entity.currentPrice,
        stockStatus: entity.stockStatus,
        productAge: entity.productAge,
        opm: entity.opm,
        transactionDatetime: entity.transactionDatetime,
        sources: entity.sources,
        note: entity.note,
        personnel: entity.personnel,
      );

  static List<VendorModel> fromJsonList(List data) =>
      data.map((dynamic i) => VendorModel.fromJson(i as Map<String, dynamic>))
          .toList();
}
