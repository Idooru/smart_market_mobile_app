import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/user/domain/entities/find_email.entity.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/reset_password.entity.dart';
import 'package:smart_market/model/user/domain/repository/auth.repository.dart';

import '../../../../core/utils/dio_initializer.dart';
import '../../../../core/utils/get_it_initializer.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioInitializer _commonHttpClient = locator<DioInitializer>(instanceName: "common");
  final DioInitializer _authenticationHttpClient = locator<DioInitializer>(instanceName: "authentication");
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/auth");

  @override
  Future<DataState<String>> findEmail(RequestFindEmail args) async {
    String url = "$_baseUrl/forgotten-email?realName=${args.realName}&phoneNumber=${args.phoneNumber}";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      String email = response.data["result"];
      return DataSuccess(data: email);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> isValidAccessToken(String accessToken) async {
    String url = "$_baseUrl/is-valid-access-token";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.get(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<String>> login(RequestLogin args) async {
    String url = "$_baseUrl/login?login-client=mobile";
    ClientArgs clientArgs = ClientArgs(email: args.email, password: args.password);
    Dio dio = _authenticationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.post(url);

      String accessToken = response.data["result"];
      return DataSuccess(data: accessToken);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> logout(String accessToken) async {
    String url = "$_baseUrl/logout?check-expired=false";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<String>> refreshToken(String accessToken) async {
    String url = "$_baseUrl/refresh-token?check-expired=false";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.patch(url);

      String accessToken = response.data["result"];
      return DataSuccess(data: accessToken);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> resetPassword(RequestResetPassword args) async {
    String url = "$_baseUrl/reset-password";
    ClientArgs clientArgs = ClientArgs(email: args.email, password: args.password);
    Dio dio = _authenticationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
