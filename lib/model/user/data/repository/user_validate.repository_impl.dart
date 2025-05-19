import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/model/user/domain/repository/user_validate.repository.dart';

class UserValidateRepositoryImpl extends DioInitializer implements UserValidateRepository {
  @override
  Future<DataState<ResponseValidate>> validateNickName(String? beforeNickName, String currentNickName, bool hasDuplicateValidation) async {
    try {
      String url =
          "$baseUrl/user/validate/nickname?${beforeNickName != null ? "before-nickname=$beforeNickName" : ""}&current-nickname=$currentNickName&has-duplicate-validation=$hasDuplicateValidation";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validatePhoneNumber(String? beforePhoneNumber, String currentPhoneNumber, bool hasDuplicateValidation) async {
    try {
      String url =
          "$baseUrl/user/validate/phonenumber?${beforePhoneNumber != null ? "before-phonenumber=$beforePhoneNumber" : ""}&current-phonenumber=$currentPhoneNumber&has-duplicate-validation=$hasDuplicateValidation";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validateAddress(String? beforeAddress, String currentAddress) async {
    try {
      String url = "$baseUrl/user/validate/address?${beforeAddress != null ? "before-address=$beforeAddress" : ""}&current-address=$currentAddress";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validateEmail(String? beforeEmail, String currentEmail, bool hasDuplicateValidation) async {
    try {
      String url = "$baseUrl/user/validate/email?${beforeEmail != null ? "before-email=$beforeEmail" : ""}&current-email=$currentEmail&has-duplicate-validation=$hasDuplicateValidation";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseValidate>> validatePassword(String newPassword, String matchPassword) async {
    try {
      String url = "$baseUrl/user/validate/password?new-password=$newPassword&match-password=$matchPassword";
      Response response = await dio.get(url);

      ResponseValidate responseValidate = ResponseValidate.fromJson(response.data);
      return DataSuccess(data: responseValidate);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
