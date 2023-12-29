abstract class VehicleEvent {
  const VehicleEvent();
}

class GetVehiclesEvent extends VehicleEvent {
  const GetVehiclesEvent();
}

class GetVehicleByVinEvent extends VehicleEvent {
  final String vin;

  const  GetVehicleByVinEvent(this.vin);
}

class GetVehicleByVicEvent extends VehicleEvent {
  final String vehicleCode;

  const GetVehicleByVicEvent(this.vehicleCode);
}
