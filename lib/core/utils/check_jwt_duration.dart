import '../../model/user/domain/service/auth.service.dart';
import '../errors/refresh_token_expired.error.dart';
import 'get_it_initializer.dart';

Future<void> checkJwtDuration() async {
  final AuthService authService = locator<AuthService>();
  bool result = await authService.checkJwtTokenDuration();
  if (!result) throw RefreshTokenExpiredError();
}
