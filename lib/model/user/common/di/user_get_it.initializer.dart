import 'package:get_it/get_it.dart';
import 'package:smart_market/model/user/data/repository/auth.repository_impl.dart';
import 'package:smart_market/model/user/data/repository/user.repository_impl.dart';
import 'package:smart_market/model/user/data/repository/user_validate.repository_impl.dart';
import 'package:smart_market/model/user/data/service/auth.service_impl.dart';
import 'package:smart_market/model/user/data/service/user.service_impl.dart';
import 'package:smart_market/model/user/data/service/user_validate.service_impl.dart';
import 'package:smart_market/model/user/domain/repository/auth.repository.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/repository/user_validate.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';

import '../../domain/service/auth.service.dart';

void initUserLocator(GetIt locator) {
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  locator.registerLazySingleton<UserValidateService>(() => UserValidateServiceImpl());
  locator.registerLazySingleton<UserValidateRepository>(() => UserValidateRepositoryImpl());
  locator.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}
