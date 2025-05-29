import '../../model/user/domain/service/user.service.dart';
import '../errors/refresh_token_expired.error.dart';
import 'get_it_initializer.dart';

Future<void> checkJwtDuration() async {
  final UserService userService = locator<UserService>();
  bool result = await userService.checkJwtTokenDuration();
  if (!result) throw RefreshTokenExpiredError();
}
