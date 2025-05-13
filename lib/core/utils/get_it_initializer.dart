import 'package:get_it/get_it.dart';
import 'package:smart_market/model/product/data/repository/product.repository_impl.dart';
import 'package:smart_market/model/product/data/service/product.service_impl.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/user/data/repository/user.repository_impl.dart';
import 'package:smart_market/model/user/data/service/user.service_impl.dart';
import 'package:smart_market/model/user/domain/repository/user.repository.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  locator.registerLazySingleton<ProductService>(() => ProductServiceImpl());
  locator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
}
