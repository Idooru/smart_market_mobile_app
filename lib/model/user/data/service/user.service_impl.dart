import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository = locator<UserRepository>();
  late SharedPreferences _prefs;

  @override
  Future<void> login(RequestLogin args) async {
    DataState<String> dataState = await _userRepository.login(args);
    if (dataState.exception != null) throw DioFailError(message: dataState.exception.toString());

    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('access-token', dataState.data!);
  }
}
