import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/model/account/data/repository/account.repository_impl.dart';
import 'package:smart_market/model/account/data/service/account.service_impl.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/product/data/repository/product.repository_impl.dart';
import 'package:smart_market/model/product/data/service/product.service_impl.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/user/data/repository/user.repository_impl.dart';
import 'package:smart_market/model/user/data/repository/user_validate.repository_impl.dart';
import 'package:smart_market/model/user/data/service/user.service_impl.dart';
import 'package:smart_market/model/user/data/service/user_validate.service_impl.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/repository/user_validate.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  final prefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => prefs);
  locator.registerLazySingleton<ProductService>(() => ProductServiceImpl());
  locator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  locator.registerLazySingleton<UserValidateService>(() => UserValidateServiceImpl());
  locator.registerLazySingleton<UserValidateRepository>(() => UserValidateRepositoryImpl());
  locator.registerLazySingleton<AccountService>(() => AccountServiceImpl());
  locator.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
}
