
import 'package:automasters/features/auto_mobile/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.tecPartName,
    super.locPartName,
    super.partCode,

    // required this.images
  });

  ProductModel copyWith({
    int? id,
    String? tecPartName,
    String? locPartName,
    String? partCode,
  }) {
    return ProductModel(
      tecPartName: tecPartName ?? this.tecPartName,
      locPartName: locPartName ?? this.locPartName,
      partCode: partCode ?? this.partCode,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      tecPartName: map['tecParName'],
      locPartName: map['locPartName'],
      partCode: map['partCode'],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
    id: entity.id,
    tecPartName: entity.tecPartName,
    locPartName: entity.locPartName,
    partCode: entity.partCode,
  );

  static List<ProductModel> fromJsonList(List data) =>
      data.map((dynamic i) => ProductModel.fromJson(i as Map<String, dynamic>))
          .toList();

  /// Empty product which has no data.
  static const empty = ProductModel(tecPartName: '',locPartName: '');

  /// Convenience getter to determine whether the current product request is empty.
  @override
  bool get isEmpty => this == ProductModel.empty;

  /// Convenience getter to determine whether the current product request is not empty.
  @override
  bool get isNotEmpty => this != ProductModel.empty;

  ///custom comparing function to check if two Products are equal
  bool isEqual(ProductModel product) {
    return id == product.id;
  }

  @override
  String toString() {
    return locPartName!.replaceFirst(locPartName![0], locPartName![0].toUpperCase());
  }
}
