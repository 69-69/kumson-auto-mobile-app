
import 'package:automasters/features/auto_mobile/domain/entities/product.dart';

class Product extends ProductEntity {
  const Product({
    int? id,
    String? techName,
    String? localName,
    String? partCode,

    // required this.images
  }) : super(
    id: id,
    techName: techName,
    localName: localName,
    partCode: partCode,
  );

  Product copyWith({
    int? id,
    String? techName,
    String? localName,
    String? partCode,
  }) {
    return Product(
      techName: techName ?? this.techName,
      localName: localName ?? this.localName,
      partCode: partCode ?? this.partCode,
    );
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      techName: map['techName'],
      localName: map['localName'],
      partCode: map['partCode'],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory Product.fromEntity(ProductEntity entity) => Product(
    id: entity.id,
    techName: entity.techName,
    localName: entity.localName,
    partCode: entity.partCode,
  );

  static List<Product> fromJsonList(List data) =>
      data.map((dynamic i) => Product.fromJson(i as Map<String, dynamic>))
          .toList();

  ///custom comparing function to check if two Products are equal
  bool isEqual(Product product) {
    return id == product.id;
  }

  @override
  String toString() {
    return localName!.replaceFirst(localName![0], localName![0].toUpperCase());
  }
}
