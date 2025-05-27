import 'package:get_it/get_it.dart';
import 'package:smart_market/model/cart/data/repository/cart.repository_impl.dart';
import 'package:smart_market/model/cart/data/service/cart.service_impl.dart';
import 'package:smart_market/model/cart/domain/repository/cart.repository.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';

void initCartLocator(GetIt locator) {
  locator.registerLazySingleton<CartService>(() => CartServiceImpl());
  locator.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());
}
