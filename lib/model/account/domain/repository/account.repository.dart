import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';

abstract interface class AccountRepository {
  Future<DataState<List<ResponseAccount>>> fetchAccounts(String accessToken, RequestAccounts args);
}
