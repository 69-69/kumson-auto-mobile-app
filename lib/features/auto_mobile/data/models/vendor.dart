import '../../domain/entities/vendor.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    super.id,
    super.partNo,
    super.brand,
    super.brandCode,
    super.brandType,
    super.vendor,
    super.vendorCode,
    super.currentPrice,
    super.stockStatus,
    super.productAge,
    super.opm,
    super.transactionDatetime,
    super.sources,
    super.note,
    super.personnel,

    // required this.images
  });

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

  /// Empty vendor which has no data.
  static const empty = VendorModel(vendor: '');

  /// Convenience getter to determine whether the current vendor request is empty.
  @override
  bool get isEmpty => this == VendorModel.empty;

  /// Convenience getter to determine whether the current vendor request is not empty.
  @override
  bool get isNotEmpty => this != VendorModel.empty;

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
