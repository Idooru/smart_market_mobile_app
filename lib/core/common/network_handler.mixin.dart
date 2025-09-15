import '../errors/connection_error.dart';
import '../errors/dio_fail.error.dart';

mixin NetWorkHandler {
  String branchErrorMessage(Object error) {
    try {
      if (error is ConnectionError) {
        return "서버와 연결되지 않습니다.";
      } else if (error is DioFailError) {
        if (error.response!.data["statusCode"] == 500) {
          return "서버 내부에서 에러가 발생하였습니다.";
        } else {
          return error.response!.data["message"];
        }
      } else {
        return "$error";
      }
    } catch (err) {
      return "";
    }
  }
}
