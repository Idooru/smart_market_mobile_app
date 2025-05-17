import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';

abstract interface class UserRepository {
  Future<DataState<void>> register(RequestRegister args);
  Future<DataState<String>> login(RequestLogin args);
  Future<DataState<void>> logout(String accessToken);
  Future<DataState<ResponseProfile>> getProfile(String accessToken);
  Future<DataState<void>> updateProfile(String accessToken, RequestUpdateProfile args);
  Future<DataState<void>> modifyPassword(String accessToken, String password);
}
