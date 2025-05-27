import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/account/common/di/account_get_it.initializer.dart';
import 'package:smart_market/model/cart/common/di/cart_get_it.initializer.dart';
import 'package:smart_market/model/product/common/di/product_get_it.initializer.dart';
import 'package:smart_market/model/user/common/di/user_get_it.initializer.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  final prefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => prefs);
  initDioLocator(locator);
  initProductLocator(locator);
  initUserLocator(locator);
  initAccountLocator(locator);
  initCartLocator(locator);
}
