import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable{
  final int? id;
  final String? tecPartName;
  final String? locPartName;
  final String? partCode;

  // final Map<String, dynamic> images;

  const ProductEntity({
    this.id,
    this.tecPartName,
    this.locPartName,
    this.partCode,

    // required this.images
  });

  /// Empty product which has no data.
  static const empty = ProductEntity(tecPartName: '', locPartName: '');

  /// Convenience getter to determine whether the current product request is empty.
  bool get isEmpty => this == ProductEntity.empty;

  /// Convenience getter to determine whether the current product request is not empty.
  bool get isNotEmpty => this != ProductEntity.empty;

  @override
  List<Object?> get props => [
    id,
    tecPartName,
    locPartName,
    partCode,
  ];
}