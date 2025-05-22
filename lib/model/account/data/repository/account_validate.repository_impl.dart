import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/account/domain/repository/account_validate.repository.dart';

class AccountValidateRepositoryImpl extends DioInitializer implements AccountValidateRepository {
  @override
  Future<DataState<ResponseValidate>> validateAccountNumber(String accountNumber) async {
    try {
      String url = "$baseUrl/account/validate/account-number/$accountNumber";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
