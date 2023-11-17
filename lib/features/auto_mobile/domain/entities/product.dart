import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable{
  final int? id;
  final String? techName;
  final String? localName;
  final String? partCode;

  // final Map<String, dynamic> images;

  const ProductEntity({
    this.id,
    this.techName,
    this.localName,
    this.partCode,

    // required this.images
  });

  @override
  List<Object?> get props => [
    id,
    techName,
    localName,
    partCode,
  ];
}