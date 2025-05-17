import 'package:dio/dio.dart';

class DioFailError extends Error {
  String? message;
  Response<dynamic>? response;

  DioFailError({
    this.message,
    this.response,
  });
}
