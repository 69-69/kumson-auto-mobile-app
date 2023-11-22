abstract class HuntersEvent {
  const HuntersEvent();
}

class GetHuntersEvent extends HuntersEvent {
  const GetHuntersEvent();
}

class GetHunterPartsByHunterNoEvent extends HuntersEvent {
  final String hunterNo;

  const GetHunterPartsByHunterNoEvent(this.hunterNo);
}

class GetHunterPartsByPartNoEvent extends HuntersEvent {
  final String partNo;

  const GetHunterPartsByPartNoEvent(this.partNo);
}
