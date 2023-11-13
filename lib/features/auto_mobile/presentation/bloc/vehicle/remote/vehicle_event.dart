abstract class VehiclesEvent {
  const VehiclesEvent();
}

class GetVehicles extends VehiclesEvent {
  const GetVehicles();
}

class GetVehicleByVin extends VehiclesEvent {
  final String vin;

  const GetVehicleByVin(this.vin);
}

class GetVehicleByVic extends VehiclesEvent {
  final String vehicleCode;

  const GetVehicleByVic(this.vehicleCode);
}
