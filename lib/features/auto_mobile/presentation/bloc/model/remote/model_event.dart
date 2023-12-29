abstract class ModelEvent {
  const ModelEvent();
}

class GetModelsEvent extends ModelEvent {
  const GetModelsEvent();
}

class GetModelsByEvent extends ModelEvent {
  final String makeRef;

  const GetModelsByEvent(this.makeRef);
}