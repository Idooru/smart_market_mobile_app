import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';
import 'package:smart_market/model/account/domain/entities/create_account.entity.dart';

abstract interface class AccountService {
  Future<List<ResponseAccount>> fetchAccounts(RequestAccounts args);
  Future<void> deposit(RequestAccountTransaction args);
  Future<void> withdraw(RequestAccountTransaction args);
  Future<void> setMainAccount(String id);
  Future<void> deleteAccount(String id);
  Future<void> createAccount(RequestCreateAccount args);
}
