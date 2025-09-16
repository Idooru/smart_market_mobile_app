class ResponseValidate {
  final bool isValidate;
  final List<String> errorMessages;

  const ResponseValidate({
    required this.isValidate,
    required this.errorMessages,
  });

  factory ResponseValidate.fromJson(Map<String, dynamic> json) {
    return ResponseValidate(
      isValidate: json["isValidate"],
      errorMessages: List<String>.from(json["errors"] ?? []),
    );
  }
}
