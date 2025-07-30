import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';

class UserRepositoryImpl implements UserRepository {
  final DioInitializer _commonHttpClient = locator<DioInitializer>(instanceName: "common");
  final DioInitializer _authenticationHttpClient = locator<DioInitializer>(instanceName: "authentication");
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/user");

  @override
  Future<DataState<void>> register(RequestRegister args) async {
    String url = "$_baseUrl/register";
    Dio dio = _commonHttpClient.getClient();

    try {
      await dio.post(url, data: args.toJson());
      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseProfile>> getProfile(String accessToken) async {
    String url = "$_baseUrl/profile";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      ResponseProfile profile = ResponseProfile.fromJson(response.data["result"]);
      return DataSuccess(data: profile);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> updateProfile(String accessToken, RequestUpdateProfile args) async {
    String url = "$_baseUrl/me";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.put(url, data: args.toJson());

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> modifyPassword(String accessToken, String password) async {
    String url = "$_baseUrl/me/password";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url, data: {"password": password});

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
