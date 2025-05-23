import 'package:get_it/get_it.dart';
import 'package:smart_market/model/account/data/repository/account.repository_impl.dart';
import 'package:smart_market/model/account/data/repository/account_validate.repository_impl.dart';
import 'package:smart_market/model/account/data/service/account.service_impl.dart';
import 'package:smart_market/model/account/data/service/account_validate.service_impl.dart';
import 'package:smart_market/model/account/domain/repository/account.repository.dart';
import 'package:smart_market/model/account/domain/repository/account_validate.repository.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/account/domain/service/account_validate.service.dart';

void initAccountLocator(GetIt locator) {
  locator.registerLazySingleton<AccountService>(() => AccountServiceImpl());
  locator.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  locator.registerLazySingleton<AccountValidateService>(() => AccountValidateServiceImpl());
  locator.registerLazySingleton<AccountValidateRepository>(() => AccountValidateRepositoryImpl());
}
