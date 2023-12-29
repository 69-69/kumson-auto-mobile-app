abstract class VendorEvent {
  const VendorEvent();
}

class GetVendors extends VendorEvent {
  const GetVendors();
}

class GetVendorPartsByBrandPartNo extends VendorEvent {
  final String brand;
  final String partNo;

  const GetVendorPartsByBrandPartNo(this.brand, this.partNo);
}

class GetVendorById extends VendorEvent {
  final int id;

  const GetVendorById(this.id);
}
