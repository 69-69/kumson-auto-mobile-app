abstract class PartEvent {
  const PartEvent();
}

class GetPartsEvent extends PartEvent {
  const GetPartsEvent();
}

class GetPartsByVFamEvent extends PartEvent {
  final String vfam;

  const GetPartsByVFamEvent(this.vfam);
}

class GetPartByHunterNoEvent extends PartEvent {
  final String hunterNo;

  const GetPartByHunterNoEvent(this.hunterNo);
}

// Get{Parts or PartsYears} ByMakeModel
class GetByMakeModelEvent extends PartEvent {
  final String make;
  final String model;

  const GetByMakeModelEvent(this.make, this.model);
}
