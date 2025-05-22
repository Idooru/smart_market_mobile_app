import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/domain/repository/account_validate.repository.dart';
import 'package:smart_market/model/account/domain/service/account_validate.service.dart';

import '../../../../core/common/service.dart' show Service;

class AccountValidateServiceImpl extends Service implements AccountValidateService {
  final AccountValidateRepository _accountRepository = locator<AccountValidateRepository>();

  @override
  Future<ResponseValidate> validateAccountNumber(String accountNumber) async {
    DataState<ResponseValidate> dataState = await _accountRepository.validateAccountNumber(accountNumber);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }
}
