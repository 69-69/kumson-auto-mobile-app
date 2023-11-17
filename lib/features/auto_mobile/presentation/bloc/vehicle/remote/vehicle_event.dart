abstract class VehiclesEvent {
  const VehiclesEvent();
}

class GetVehiclesEvent extends VehiclesEvent {
  const GetVehiclesEvent();
}

class GetVehicleByVinEvent extends VehiclesEvent {
  final String vin;

  const GetVehicleByVinEvent(this.vin);
}

class GetVehicleByVicEvent extends VehiclesEvent {
  final String vehicleCode;

  const GetVehicleByVicEvent(this.vehicleCode);
}
