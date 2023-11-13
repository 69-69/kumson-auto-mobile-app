abstract class VendorsEvent {
  const VendorsEvent();
}

class GetVendors extends VendorsEvent {
  const GetVendors();
}

class GetVendorPartsByBrandPartNo extends VendorsEvent {
  final String brand;
  final String partNo;

  const GetVendorPartsByBrandPartNo(this.brand, this.partNo);
}

class GetVendorById extends VendorsEvent {
  final int id;

  const GetVendorById(this.id);
}
