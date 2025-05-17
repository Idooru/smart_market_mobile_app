import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/common/service.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

class UserServiceImpl extends Service implements UserService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final UserRepository _userRepository = locator<UserRepository>();

  @override
  Future<void> register(RequestRegister args) async {
    DataState<void> dataState = await _userRepository.register(args);
    if (dataState.exception != null) throwDioFailError(dataState);
  }

  @override
  Future<void> login(RequestLogin args) async {
    DataState<String> dataState = await _userRepository.login(args);
    if (dataState.exception != null) throwDioFailError(dataState);
    _db.setString('access-token', dataState.data!);
  }

  @override
  Future<void> logout() async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _userRepository.logout(accessToken!);
    if (dataState.exception != null) throwDioFailError(dataState);
    _db.remove("access-token");
  }

  @override
  Future<ResponseProfile> getProfile() async {
    String? accessToken = _db.getString("access-token");
    DataState<ResponseProfile> dataState = await _userRepository.getProfile(accessToken!);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> updateProfile(RequestUpdateProfile args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _userRepository.updateProfile(accessToken!, args);
    if (dataState.exception != null) throwDioFailError(dataState);
  }

  @override
  Future<void> modifyPassword(String password) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _userRepository.modifyPassword(accessToken!, password);
    if (dataState.exception != null) throwDioFailError(dataState);
  }
}
