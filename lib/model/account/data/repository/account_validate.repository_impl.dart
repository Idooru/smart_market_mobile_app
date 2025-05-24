import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/domain/repository/account_validate.repository.dart';

class AccountValidateRepositoryImpl implements AccountValidateRepository {
  final DioInitializer _commonHttpClient = locator<DioInitializer>(instanceName: "common");
  final String _baseUrl = RequestUrl.getUrl("/account/validate");

  @override
  Future<DataState<ResponseValidate>> validateAccountNumber(String accountNumber) async {
    String url = "$_baseUrl/account-number/$accountNumber";
    Dio dio = await _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
