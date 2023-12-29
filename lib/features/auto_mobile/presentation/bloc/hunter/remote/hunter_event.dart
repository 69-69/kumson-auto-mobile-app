abstract class HunterEvent {
  const HunterEvent();
}

class GetHuntersEvent extends HunterEvent {
  const GetHuntersEvent();
}

class GetHunterPartsByHunterNoEvent extends HunterEvent {
  final String hunterNo;

  const GetHunterPartsByHunterNoEvent(this.hunterNo);
}

class GetHunterPartsByPartNoEvent extends HunterEvent {
  final String partNo;

  const GetHunterPartsByPartNoEvent(this.partNo);
}
