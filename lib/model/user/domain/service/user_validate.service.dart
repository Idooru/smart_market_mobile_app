import 'package:smart_market/core/common/validate.entity.dart';

abstract interface class UserValidateService {
  Future<ResponseValidate> validateNickName({String? beforeNickName, required String currentNickName});
  Future<ResponseValidate> validatePhoneNumber({String? beforePhoneNumber, required String currentPhoneNumber});
  Future<ResponseValidate> validateAddress({String? beforeAddress, required String currentAddress});
  Future<ResponseValidate> validateEmail({String? beforeEmail, required String currentEmail});
  Future<ResponseValidate> validatePassword({required String newPassword, required String matchPassword});
}
