import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';

mixin NetWorkHandler {
  String branchErrorMessage(DioFailError err) {
    if (err.message == "none connection") {
      return "서버와 연결되지 않습니다.";
    } else if (err.response!.data["statusCode"] == 500) {
      return "서버 내부에서 에러가 발생하였습니다.";
    } else {
      return err.response!.data["reason"];
    }
  }

  Widget getErrorMessageWidget(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
