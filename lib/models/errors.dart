class Errors {
  final String error;

  Errors({required this.error});

  factory Errors.fromJson(Map<String, dynamic> json) =>
      Errors(error: json['error']);
}
