import '../../../../core/common/data_state.dart';
import '../entities/find_email.entity.dart';
import '../entities/login.entity.dart';
import '../entities/reset_password.entity.dart';

abstract interface class AuthRepository {
  Future<DataState<String>> findEmail(RequestFindEmail args);
  Future<DataState<void>> resetPassword(RequestResetPassword args);
  Future<DataState<String>> login(RequestLogin args);
  Future<DataState<void>> logout(String accessToken);
  Future<DataState<void>> isValidAccessToken(String accessToken);
  Future<DataState<String>> refreshToken(String accessToken);
}
