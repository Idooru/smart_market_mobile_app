import 'package:smart_market/model/account/domain/entities/account.entity.dart';

abstract interface class AccountService {
  Future<List<ResponseAccount>> getAccounts(RequestAccounts args);
}
