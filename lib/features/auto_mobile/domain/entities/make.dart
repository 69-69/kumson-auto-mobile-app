import 'package:equatable/equatable.dart';

class MakeEntity extends Equatable {
  final int? id;
  final String? make;
  final String? makeRef;
  final String? note;
  final String? personnel;

  // final Map<String, dynamic> images;

  const MakeEntity({
    this.id,
    this.make,
    this.makeRef,
    this.note,
    this.personnel,

    // required this.images
  });

  /// Empty Make which has no data.
  static const empty = MakeEntity(make: '');

  /// Convenience getter to determine whether the current Make request is empty.
  bool get isEmpty => this == MakeEntity.empty;

  /// Convenience getter to determine whether the current Make request is not empty.
  bool get isNotEmpty => this != MakeEntity.empty;

  @override
  List<Object?> get props => [
        id,
        make,
        makeRef,
        note,
        personnel,
      ];
}
