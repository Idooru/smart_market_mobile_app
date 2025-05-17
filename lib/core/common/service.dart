import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';

class Service {
  void throwDioFailError(DataState dataState) {
    if (dataState.exception!.response == null) {
      throw DioFailError(message: "none connection");
    }

    throw DioFailError(response: dataState.exception!.response!);
  }
}
