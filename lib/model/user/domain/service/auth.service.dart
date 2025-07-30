import '../entities/find_email.entity.dart';
import '../entities/login.entity.dart';
import '../entities/reset_password.entity.dart';

abstract interface class AuthService {
  Future<String> findEmail(RequestFindEmail args);
  Future<void> resetPassword(RequestResetPassword args);
  Future<void> login(RequestLogin args);
  Future<void> logout();
  Future<bool> checkJwtTokenDuration();
}
