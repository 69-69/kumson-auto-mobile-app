import 'package:automasters/features/auto_mobile/domain/entities/make.dart';

class MakeModel extends MakeEntity {
  const MakeModel({
    super.id,
    super.make,
    super.makeRef,
    super.note,
    super.personnel,

    // required this.images
  });

  MakeModel copyWith({
    int? id,
    String? make,
    String? makeRef,
    String? note,
    String? personnel,
  }) {
    return MakeModel(
      id: id ?? this.id,
      make: make ?? this.make,
      makeRef: makeRef ?? this.makeRef,
      note: note ?? this.note,
      personnel: personnel ?? this.personnel,
    );
  }

  factory MakeModel.fromJson(Map<String, dynamic> map) {
    return MakeModel(
      id: map['id'],
      make: map['make'],
      makeRef: map['makeRef'],
      note: map['note'],
      personnel: map['personnel'],
      // images: map['vehicleImages'],
    );
  }

  /// Convert object toMap / toJson[toMap]
  factory MakeModel.fromEntity(MakeEntity entity) => MakeModel(
        id: entity.id,
        make: entity.make,
        makeRef: entity.makeRef,
        note: entity.note,
        personnel: entity.personnel,
      );

  // Convert List of Map<String, dynamic> to Dynamic List
  static List<MakeModel> fromJsonList(List data) =>
      data.map((dynamic i) => MakeModel.fromJson(i as Map<String, dynamic>))
          .toList();



  // Convert List of Map<String, dynamic> to List of String
  static List<String> fromMapList(List data) => List<String>.from(data);

  /// Empty Make which has no data.
  static const empty = MakeModel(make: '');

  /// Convenience getter to determine whether the current Make request is empty.
  @override
  bool get isEmpty => this == MakeModel.empty;

  /// Convenience getter to determine whether the current Make request is not empty.
  @override
  bool get isNotEmpty => this != MakeModel.empty;

  ///custom comparing function to check if two models are equal
  bool isEqual(MakeModel model) {
    return id == model.id;
  }

  @override
  String toString() {
    return make!.replaceFirst(make![0], make![0].toUpperCase());
  }
}
