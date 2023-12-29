import 'package:equatable/equatable.dart';

class SMSConfigModel extends Equatable {
  final String? smsKey;
  final String? smsUrl;
  final String? senderID;

  const SMSConfigModel({
    this.smsKey,
    this.senderID,
    this.smsUrl,
  });

  factory SMSConfigModel.fromJson(Map<String, dynamic> json) {
    return SMSConfigModel(
      smsKey: json['smsKey'],
      smsUrl: json['smsUrl'],
      senderID: json['senderID'],
    );
  }

  /// Update smsKey Object/Model property[copy]
  SMSConfigModel copy({
    String? smsKey,
    String? smsUrl,
    String? senderID,
  }) =>
      SMSConfigModel(
        smsKey: smsKey ?? "",
        smsUrl: smsUrl ?? "",
        senderID: senderID ?? "",
      );

  /// Empty smsKey which represents an unknown.
  static const empty = SMSConfigModel(smsKey: '');

  /// Convenience getter to determine whether the current smsKey is empty.
  bool get isEmpty => this == SMSConfigModel.empty;

  /// Convenience getter to determine whether the current smsKey is not empty.
  bool get isNotEmpty => this != SMSConfigModel.empty;

  @override
  List<Object?> get props => [smsKey, smsUrl, senderID];
}
