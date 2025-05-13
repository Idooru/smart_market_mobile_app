import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkIsLogined() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access-token");
  return accessToken != null;
}
