import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/validate.entity.dart';

abstract interface class AccountValidateRepository {
  Future<DataState<ResponseValidate>> validateAccountNumber(String accountNumber);
}
