import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;

  const DataState({this.data, this.exception});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({required super.data});
}

class DataFail<T> extends DataState<T> {
  const DataFail({required super.exception});
}
