import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';

abstract interface class AccountRepository {
  Future<DataState<List<ResponseAccount>>> fetchAccounts(String accessToken, RequestAccounts args);
  Future<DataState<void>> deposit(String accessToken, RequestAccountTransaction args);
  Future<DataState<void>> withdraw(String accessToken, RequestAccountTransaction args);
}
