import '../../domain/entities/account.entity.dart';

class RequestAccountsArgs {
  static RequestAccounts _args = const RequestAccounts(align: "DESC", column: "createdAt");
  static RequestAccounts get args => _args;

  static void setArgs(RequestAccounts args) {
    _args = args;
  }
}
