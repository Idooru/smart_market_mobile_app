import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';

abstract interface class UserService {
  Future<void> login(RequestLogin args);
  Future<void> logout();
  Future<ResponseProfile> getProfile();
}
