import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/core/common/service.dart';

class AccountServiceImpl extends Service implements AccountService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final AccountRepository _accountRepository = locator<AccountRepository>();

  @override
  Future<List<ResponseAccount>> getAccounts(RequestAccounts args) async {
    String? accessToken = _db.getString("access-token");
    DataState<List<ResponseAccount>> dataState = await _accountRepository.fetchAccounts(accessToken!, args);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }
}
