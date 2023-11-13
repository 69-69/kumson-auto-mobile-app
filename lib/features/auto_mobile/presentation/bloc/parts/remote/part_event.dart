abstract class PartsEvent {
  const PartsEvent();
}

class GetParts extends PartsEvent {
  const GetParts();
}

class GetPartsByVFam extends PartsEvent {
  final String vfam;

  const GetPartsByVFam(this.vfam);
}

class GetPartByHunterNo extends PartsEvent {
  final String hunterNo;

  const GetPartByHunterNo(this.hunterNo);
}

// Get{Parts or PartsYears} ByMakeModel
class GetByMakeModel extends PartsEvent {
  final String make;
  final String model;

  const GetByMakeModel(this.make, this.model);
}
