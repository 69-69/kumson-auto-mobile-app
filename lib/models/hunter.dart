class HunterModel {
  final int id;
  final String product;
  final String partNo;
  final String brand;
  final String brandCode;
  final String productCode;
  final String productStatus;
  final String hunter;
  final String sku;
  final String universalPartNo;
  final String manufacturerNo;
  final String manufacturerType;
  final String sources;
  final String personnel;
  final String note;

  // final Map<String, dynamic> images;

  HunterModel({
    this.id = 0,
    this.product = "",
    this.partNo = "",
    this.brand = "",
    this.brandCode = "",
    this.productCode = "",
    this.productStatus = "",
    this.hunter = "",
    this.sku = "",
    this.universalPartNo = "",
    this.manufacturerNo = "",
    this.manufacturerType = "",
    this.sources = "",
    this.personnel = "",
    this.note = "",
    // required this.images
  });

  factory HunterModel.fromJson(Map<String, dynamic> json) {
    return HunterModel(
      id: json['id'],
      partNo: json['partNo'],
      brand: json['brand'],
      brandCode: json['brandCode'],
      product: json['product'],
      productCode: json['productCode'],
      productStatus: json['productStatus'],
      hunter: json['hunter'],
      sku: json['sku'],
      universalPartNo: json['universalPartNo'],
      manufacturerNo: json['manufacturerNo'],
      manufacturerType: json['manufacturerType'],
      sources: json['sources'],
      personnel: json['personnel'],
      note: json['note'],
      // images: json['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  static Map<String, dynamic> toMap(HunterModel item) => {
        "id": item.id,
        "product": item.product,
        "partNo": item.partNo,
        "brand": item.brand,
        "brandCode": item.brandCode,
        "productCode": item.productCode,
        "productStatus": item.productStatus,
        "hunter": item.hunter,
        "sku": item.sku,
        "universalPartNo": item.universalPartNo,
        "manufacturerNo": item.manufacturerNo,
        "manufacturerType": item.manufacturerType,
        "sources": item.sources,
        "personnel": item.personnel,
        "note": item.note,
      };

  /// Update Parts Object/Model property[copy]
  HunterModel copy({
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
    String? personnel,
    String? note,
    // Map<String, dynamic>? images,
  }) =>
      HunterModel(
        id: id ?? 0,
        product: product ?? "",
        partNo: partNo ?? "",
        brand: brand ?? "",
        brandCode: brandCode ?? "",
        productCode: productCode ?? "",
        productStatus: productStatus ?? "",
        hunter: hunter ?? "",
        sku: sku ?? "",
        universalPartNo: universalPartNo ?? "",
        manufacturerNo: manufacturerNo ?? "",
        manufacturerType: manufacturerType ?? "",
        sources: sources ?? "",
        personnel: personnel ?? "",
        note: note ?? "",
        // images: images ?? {},
      );
}
