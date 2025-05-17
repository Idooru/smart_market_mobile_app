import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/model/user/domain/repository/user_validate.repository.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';

import '../../../../core/common/service.dart';

class UserValidateServiceImpl extends Service implements UserValidateService {
  final UserValidateRepository _userRepository = locator<UserValidateRepository>();

  @override
  Future<ResponseValidate> validateNickName({String? beforeNickName, required String currentNickName}) async {
    DataState<ResponseValidate> dataState = await _userRepository.validateNickName(beforeNickName, currentNickName);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseValidate> validatePhoneNumber({String? beforePhoneNumber, required String currentPhoneNumber}) async {
    DataState<ResponseValidate> dataState = await _userRepository.validatePhoneNumber(beforePhoneNumber, currentPhoneNumber);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseValidate> validateAddress({String? beforeAddress, required String currentAddress}) async {
    DataState<ResponseValidate> dataState = await _userRepository.validateAddress(beforeAddress, currentAddress);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseValidate> validateEmail({String? beforeEmail, required String currentEmail}) async {
    DataState<ResponseValidate> dataState = await _userRepository.validateEmail(beforeEmail, currentEmail);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseValidate> validatePassword({required String newPassword, required String matchPassword}) async {
    DataState<ResponseValidate> dataState = await _userRepository.validatePassword(newPassword, matchPassword);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }
}
