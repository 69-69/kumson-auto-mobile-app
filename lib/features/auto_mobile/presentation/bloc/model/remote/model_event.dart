abstract class ModelsEvent {
  const ModelsEvent();
}

class GetModelsEvent extends ModelsEvent {
  const GetModelsEvent();
}

class GetModelsByEvent extends ModelsEvent {
  final String makeRef;

  const GetModelsByEvent(this.makeRef);
}