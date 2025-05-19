import 'package:smart_market/core/common/validate.entity.dart';

abstract interface class UserValidateService {
  Future<ResponseValidate> validateNickName({String? beforeNickName, required String currentNickName, required bool hasDuplicateValidation});
  Future<ResponseValidate> validatePhoneNumber({String? beforePhoneNumber, required String currentPhoneNumber, required bool hasDuplicateValidation});
  Future<ResponseValidate> validateAddress({String? beforeAddress, required String currentAddress});
  Future<ResponseValidate> validateEmail({String? beforeEmail, required String currentEmail, required bool hasDuplicateValidation});
  Future<ResponseValidate> validatePassword({required String newPassword, required String matchPassword});
}
