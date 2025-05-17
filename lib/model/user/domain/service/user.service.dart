import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';

abstract interface class UserService {
  Future<void> register(RequestRegister args);
  Future<void> login(RequestLogin args);
  Future<void> logout();
  Future<ResponseProfile> getProfile();
  Future<void> updateProfile(RequestUpdateProfile args);
  Future<void> modifyPassword(String password);
}
