class VendorModel {
  final int id;
  final String partNo;
  final String brand;
  final String brandCode;
  final String brandType;
  final String vendor;
  final String vendorCode;
  final int currentPrice;
  final String stockStatus;
  final String productAge;
  final String opm;
  final String transactionDatetime;
  final String sources;
  final String note;
  final String personnel;

  // final Map<String, dynamic> images;

  VendorModel({
    this.id = 0,
    this.partNo = "",
    this.brand = "",
    this.brandCode = "",
    this.brandType = "",
    this.vendor = "",
    this.vendorCode = "",
    this.currentPrice = 0,
    this.stockStatus = "",
    this.productAge = "",
    this.opm = "",
    this.transactionDatetime = "",
    this.sources = "",
    this.note = "",
    this.personnel = "",
    // required this.images
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      opm: json['opm'],
      transactionDatetime: json['transactionDatetime'],
      sources: json['sources'],
      note: json['note'],
      personnel: json['personnel'],
      partNo: json['partNo'],
      brand: json['brand'],
      brandCode: json['brandCode'],
      brandType: json['brandType'],
      vendor: json['vendor'],
      vendorCode: json['vendorCode'],
      currentPrice: json['currentPrice'],
      stockStatus: json['stockStatus'],
      productAge: json['productAge'],
      // images: json['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  static Map<String, dynamic> toMap(VendorModel item) => {
        "id": item.id,
        "opm": item.opm,
        "transactionDatetime": item.transactionDatetime,
        "sources": item.sources,
        "note": item.note,
        "personnel": item.personnel,
        "partNo": item.partNo,
        "brand": item.brand,
        "brandCode": item.brandCode,
        "brandType": item.brandType,
        "vendor": item.vendor,
        "vendorCode": item.vendorCode,
        "currentPrice": item.currentPrice,
        "stockStatus": item.stockStatus,
        "productAge": item.productAge,
      };

  /// Update Parts Object/opm property[copy]
  VendorModel copy({
    int? id,
    String? opm,
    String? transactionDatetime,
    String? sources,
    String? note,
    String? personnel,
    String? partNo,
    String? brand,
    String? brandCode,
    String? brandType,
    String? vendor,
    String? vendorCode,
    int? currentPrice,
    String? stockStatus,
    String? productAge,
    // Map<String, dynamic>? images,
  }) =>
      VendorModel(
        id: id ?? 0,
        opm: opm ?? "",
        transactionDatetime: transactionDatetime ?? "",
        sources: sources ?? "",
        note: note ?? "",
        personnel: personnel ?? "",
        partNo: partNo ?? "",
        brand: brand ?? "",
        brandCode: brandCode ?? "",
        brandType: brandType ?? "",
        vendor: vendor ?? "",
        vendorCode: vendorCode ?? "",
        currentPrice: currentPrice ?? 0,
        stockStatus: stockStatus ?? "",
        productAge: productAge ?? "",
      );
}
