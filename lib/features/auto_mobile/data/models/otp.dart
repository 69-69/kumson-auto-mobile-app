import 'package:equatable/equatable.dart';

class OTPModel extends Equatable {
  final String otp;
  final DateTime? otpExpiry;

  const OTPModel({
    this.otp = "",
    this.otpExpiry,
  });

  factory OTPModel.fromJson(Map<String, dynamic> json) {
    return OTPModel(
      otp: json['otp'],
      otpExpiry: json['otpExpiry'],
    );
  }

  /// Update OTP Object/Model property[copy]
  OTPModel copy({
    String? otp,
    DateTime? otpExpiry,
  }) =>
      OTPModel(
        otp: otp ?? "",
        otpExpiry: otpExpiry,
      );


  /// Empty otp which represents an unknown.
  static const empty = OTPModel(otp: '');

  /// Convenience getter to determine whether the current otp is empty.
  bool get isEmpty => this == OTPModel.empty;

  /// Convenience getter to determine whether the current otp is not empty.
  bool get isNotEmpty => this != OTPModel.empty;

  @override
  List<Object?> get props => [otp, otpExpiry];


}
