import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/errors/connection_error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/throw_network_error.dart';
import 'package:smart_market/model/user/domain/entities/find_email.entity.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';
import 'package:smart_market/model/user/domain/entities/reset_password.entity.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

import '../../../../core/errors/dio_fail.error.dart';

class UserServiceImpl implements UserService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final UserRepository _userRepository = locator<UserRepository>();

  Future<bool> refreshToken(String accessToken) async {
    DataState<String> dataState = await _userRepository.refreshToken(accessToken);
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
    DataState<void> dataState = await _userRepository.isValidAccessToken(accessToken!);
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
  Future<void> register(RequestRegister args) async {
    DataState<void> dataState = await _userRepository.register(args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<String> findEmail(RequestFindEmail args) async {
    DataState<String> dataState = await _userRepository.findEmail(args);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> resetPassword(RequestResetPassword args) async {
    DataState<void> dataState = await _userRepository.resetPassword(args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> login(RequestLogin args) async {
    DataState<String> dataState = await _userRepository.login(args);
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
    DataState<void> dataState = await _userRepository.logout(accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);

    _db.remove("access-token");
    _db.remove("user-info");
  }

  @override
  Future<ResponseProfile> getProfile() async {
    String? accessToken = _db.getString("access-token");
    DataState<ResponseProfile> dataState = await _userRepository.getProfile(accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> updateProfile(RequestUpdateProfile args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _userRepository.updateProfile(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> modifyPassword(String password) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _userRepository.modifyPassword(accessToken!, password);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
