import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';
import 'package:smart_market/model/account/domain/entities/create_account.entity.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';

import '../../../../core/utils/throw_network_error.dart';

class AccountServiceImpl implements AccountService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final AccountRepository _accountRepository = locator<AccountRepository>();

  @override
  Future<List<ResponseAccount>> fetchAccounts(RequestAccounts args) async {
    String? accessToken = _db.getString("access-token");
    DataState<List<ResponseAccount>> dataState = await _accountRepository.fetchAccounts(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> deposit(RequestAccountTransaction args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _accountRepository.deposit(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> withdraw(RequestAccountTransaction args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _accountRepository.withdraw(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> setMainAccount(String id) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _accountRepository.setMainAccount(accessToken!, id);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> deleteAccount(String id) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _accountRepository.deleteAccount(accessToken!, id);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> createAccount(RequestCreateAccount args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _accountRepository.createAccount(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
