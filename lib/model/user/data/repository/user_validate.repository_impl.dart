import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/domain/repository/user_validate.repository.dart';

class UserValidateRepositoryImpl implements UserValidateRepository {
  final DioInitializer _commonHttpClient = locator<DioInitializer>(instanceName: "common");
  final String _baseUrl = RequestUrl.getUrl("/validate/user");

  @override
  Future<DataState<ResponseValidate>> validateNickName(String? beforeNickName, String currentNickName, bool hasDuplicateValidation) async {
    String url = "$_baseUrl/nickname?${beforeNickName != null ? "before-nickname=$beforeNickName" : ""}&current-nickname=$currentNickName&has-duplicate-validation=$hasDuplicateValidation";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validatePhoneNumber(String? beforePhoneNumber, String currentPhoneNumber, bool hasDuplicateValidation) async {
    String url =
        "$_baseUrl/phone-number?${beforePhoneNumber != null ? "before-phone-number=$beforePhoneNumber" : ""}&current-phone-number=$currentPhoneNumber&has-duplicate-validation=$hasDuplicateValidation";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validateAddress(String? beforeAddress, String currentAddress) async {
    String url = "$_baseUrl/address?${beforeAddress != null ? "before-address=$beforeAddress" : ""}&current-address=$currentAddress";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validateEmail(String? beforeEmail, String currentEmail, bool hasDuplicateValidation) async {
    String url = "$_baseUrl/email?${beforeEmail != null ? "before-email=$beforeEmail" : ""}&current-email=$currentEmail&has-duplicate-validation=$hasDuplicateValidation";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validatePassword(String newPassword, String matchPassword) async {
    String url = "$_baseUrl/password?new-password=$newPassword&match-password=$matchPassword";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
