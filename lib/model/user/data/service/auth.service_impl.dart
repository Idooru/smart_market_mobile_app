import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/model/user/domain/entities/find_email.entity.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/reset_password.entity.dart';
import 'package:smart_market/model/user/domain/service/auth.service.dart';

import '../../../../core/common/data_state.dart';
import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/utils/throw_network_error.dart';
import '../../domain/repository/auth.repository.dart';

class AuthServiceImpl implements AuthService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final AuthRepository _authRepository = locator<AuthRepository>();

  Future<bool> refreshToken(String accessToken) async {
    DataState<String> dataState = await _authRepository.refreshToken(accessToken);
    if (dataState.exception != null) {
      if (dataState.exception!.response == null) {
        throw ConnectionError();
      }
      if (dataState.exception!.response!.statusCode! == 401) {
        return false;
      } else {
        throw DioFailError(response: dataState.exception!.response!);
      }
    }

    _db.setString('access-token', dataState.data!);
    return true;
  }

  @override
  Future<bool> checkJwtTokenDuration() async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _authRepository.isValidAccessToken(accessToken!);
    bool flag = false;

    if (dataState.exception != null) {
      if (dataState.exception!.response == null) {
        throw ConnectionError();
      } else if (dataState.exception!.response!.statusCode! == 401) {
        flag = await refreshToken(accessToken);
      } else {
        throw DioFailError(response: dataState.exception!.response!);
      }
    } else {
      flag = true;
    }

    return flag;
  }

  @override
  Future<String> findEmail(RequestFindEmail args) async {
    DataState<String> dataState = await _authRepository.findEmail(args);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> login(RequestLogin args) async {
    DataState<String> dataState = await _authRepository.login(args);
    if (dataState.exception != null) branchNetworkError(dataState);

    String accessToken = dataState.data!;
    Map<String, dynamic> json = JwtDecoder.decode(accessToken);
    String encoded = jsonEncode(json);

    _db.setString('access-token', accessToken);
    _db.setString("user-info", encoded);
  }

  @override
  Future<void> logout() async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _authRepository.logout(accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);

    _db.remove("access-token");
    _db.remove("user-info");
  }

  @override
  Future<void> resetPassword(RequestResetPassword args) async {
    DataState<void> dataState = await _authRepository.resetPassword(args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
