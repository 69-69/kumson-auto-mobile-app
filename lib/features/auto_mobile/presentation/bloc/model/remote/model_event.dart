abstract class ModelsEvent {
  const ModelsEvent();
}

class GetModels extends ModelsEvent {
  const GetModels();
}

class GetModelsBy extends ModelsEvent {
  final String makeRef;

  const GetModelsBy(this.makeRef);
}
