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

  @override
  List<Object?> get props => [
        id,
        make,
        makeRef,
        note,
        personnel,
      ];
}
