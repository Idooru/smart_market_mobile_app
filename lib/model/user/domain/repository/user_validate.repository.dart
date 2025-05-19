import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';

abstract interface class UserValidateRepository {
  Future<DataState<ResponseValidate>> validateNickName(String? beforeNickName, String currentNickName, bool hasDuplicateValidation);
  Future<DataState<ResponseValidate>> validatePhoneNumber(String? beforePhoneNumber, String currentPhoneNumber, bool hasDuplicateValidation);
  Future<DataState<ResponseValidate>> validateAddress(String? beforeAddress, String currentAddress);
  Future<DataState<ResponseValidate>> validateEmail(String? beforeEmail, String currentEmail, bool hasDuplicateValidation);
  Future<DataState<ResponseValidate>> validatePassword(String newPassword, String matchPassword);
}
