import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';

class UserRepositoryImpl extends DioInitializer implements UserRepository {
  @override
  Future<DataState<String>> login(RequestLogin args) async {
    try {
      String url = "$baseUrl/user/login";
      Response response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${args.email}:${args.password}'))}'},
        ),
      );

      String accessToken = response.headers["access-token"]![0];
      return DataSuccess(data: accessToken);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> logout(String accessToken) async {
    try {
      String url = "$baseUrl/user/logout";
      await dio.delete(
        url,
        options: Options(headers: {'access-token': accessToken}),
      );

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseProfile>> getProfile(String accessToken) async {
    try {
      String url = "$baseUrl/user/profile";
      Response response = await dio.get(
        url,
        options: Options(headers: {'access-token': accessToken}),
      );
      ResponseProfile profile = ResponseProfile.fromJson(response.data["result"]);

      return DataSuccess(data: profile);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
