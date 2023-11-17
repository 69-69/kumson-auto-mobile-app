abstract class PartsEvent {
  const PartsEvent();
}

class GetPartsEvent extends PartsEvent {
  const GetPartsEvent();
}

class GetPartsByVFamEvent extends PartsEvent {
  final String vfam;

  const GetPartsByVFamEvent(this.vfam);
}

class GetPartByHunterNoEvent extends PartsEvent {
  final String hunterNo;

  const GetPartByHunterNoEvent(this.hunterNo);
}

// Get{Parts or PartsYears} ByMakeModel
class GetByMakeModelEvent extends PartsEvent {
  final String make;
  final String model;

  const GetByMakeModelEvent(this.make, this.model);
}
