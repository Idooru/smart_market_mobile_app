class ResponseValidate {
  final bool isValidate;
  final String message;

  const ResponseValidate({
    required this.isValidate,
    required this.message,
  });

  factory ResponseValidate.fromJson(Map<String, dynamic> json) {
    return ResponseValidate(
      isValidate: json["isValidate"],
      message: json["message"],
    );
  }
}
