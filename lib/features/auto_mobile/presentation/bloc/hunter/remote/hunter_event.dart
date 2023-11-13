abstract class HuntersEvent {
  const HuntersEvent();
}

class GetHunters extends HuntersEvent {
  const GetHunters();
}

class GetHunterPartsByHunterNo extends HuntersEvent {
  final String hunterNo;

  const GetHunterPartsByHunterNo(this.hunterNo);
}

class GetHunterPartsByPartNo extends HuntersEvent {
  final String partNo;

  const GetHunterPartsByPartNo(this.partNo);
}
