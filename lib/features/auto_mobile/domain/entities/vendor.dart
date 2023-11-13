import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  final int ? id;
  final String ? partNo;
  final String ? brand;
  final String ? brandCode;
  final String ? brandType;
  final String ? vendor;
  final String ? vendorCode;
  final int ? currentPrice;
  final String ? stockStatus;
  final String ? productAge;
  final String ? opm;
  final String ? transactionDatetime;
  final String ? sources;
  final String ? note;
  final String ? personnel;

  // final Map<String, dynamic> images;

  const VendorEntity({
    this.id,
    this.partNo,
    this.brand,
    this.brandCode,
    this.brandType,
    this.vendor,
    this.vendorCode,
    this.currentPrice,
    this.stockStatus,
    this.productAge,
    this.opm,
    this.transactionDatetime,
    this.sources,
    this.note,
    this.personnel,

    // required this.images
  });

  @override
  List<Object?> get props => [
    id,
    partNo,
    brand,
    brandCode,
    brandType,
    vendor,
    vendorCode,
    currentPrice,
    stockStatus,
    productAge,
    opm,
    transactionDatetime,
    sources,
    note,
    personnel,
  ];
}
