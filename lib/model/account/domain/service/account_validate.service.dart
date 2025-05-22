import 'package:smart_market/core/common/validate.entity.dart';

abstract interface class AccountValidateService {
  Future<ResponseValidate> validateAccountNumber(String accountNumber);
}
