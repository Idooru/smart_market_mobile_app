import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';

bool checkIsLogined() {
  SharedPreferences db = locator<SharedPreferences>();
  String? accessToken = db.getString("access-token");
  return accessToken != null;
}
