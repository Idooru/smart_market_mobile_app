import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';
import 'package:smart_market/model/account/domain/entities/create_account.entity.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/account");

  @override
  Future<DataState<List<ResponseAccount>>> fetchAccounts(String accessToken, RequestAccounts args) async {
    String url = "$_baseUrl/all?align=${args.align}&column=${args.column}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      List<ResponseAccount> accounts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseAccount.fromJson(data)).toList();
      return DataSuccess(data: accounts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deposit(String accessToken, RequestAccountTransaction args) async {
    String url = "$_baseUrl/${args.id}/deposit";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url, data: {"balance": args.balance});

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> withdraw(String accessToken, RequestAccountTransaction args) async {
    String url = "$_baseUrl/${args.id}/withdraw";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url, data: {"balance": args.balance});

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> setMainAccount(String accessToken, String id) async {
    String url = "$_baseUrl/$id/main-account";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deleteAccount(String accessToken, String id) async {
    String url = "$_baseUrl/$id";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> createAccount(String accessToken, RequestCreateAccount args) async {
    String url = _baseUrl;
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = await _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.post(url, data: args.toJson());

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
