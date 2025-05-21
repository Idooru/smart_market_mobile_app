import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';

class AccountRepositoryImpl extends DioInitializer implements AccountRepository {
  @override
  Future<DataState<List<ResponseAccount>>> fetchAccounts(String accessToken, RequestAccounts args) async {
    try {
      String url = "$baseUrl/account/all?align=${args.align}&column=${args.column}";
      Response response = await dio.get(
        url,
        options: Options(headers: {'access-token': accessToken}),
      );

      List<ResponseAccount> accounts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseAccount.fromJson(data)).toList();
      return DataSuccess(data: accounts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deposit(String accessToken, RequestAccountTransaction args) async {
    try {
      String url = "$baseUrl/account/${args.id}/deposit";
      await dio.patch(
        url,
        options: Options(headers: {'access-token': accessToken}),
        data: {"balance": args.balance},
      );

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> withdraw(String accessToken, RequestAccountTransaction args) async {
    try {
      String url = "$baseUrl/account/${args.id}/withdraw";
      await dio.patch(
        url,
        options: Options(headers: {'access-token': accessToken}),
        data: {"balance": args.balance},
      );

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
