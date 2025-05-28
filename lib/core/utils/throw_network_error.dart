import '../common/data_state.dart';
import '../errors/connection_error.dart';
import '../errors/dio_fail.error.dart';

void branchNetworkError(DataState dataState) {
  if (dataState.exception!.response == null) {
    throw ConnectionError();
  }

  throw DioFailError(response: dataState.exception!.response!);
}
