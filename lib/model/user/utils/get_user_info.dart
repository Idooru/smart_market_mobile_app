import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/get_it_initializer.dart';
import '../domain/entities/user_info.entity.dart';

UserInfo getUserInfo() {
  SharedPreferences db = locator<SharedPreferences>();
  String? userInfoStr = db.getString("user-info");
  Map<String, dynamic> userInfoJson = jsonDecode(userInfoStr!);
  return UserInfo.fromJson(userInfoJson);
}
