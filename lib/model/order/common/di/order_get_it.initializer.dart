import 'package:get_it/get_it.dart';
import 'package:smart_market/model/order/data/repository/order.repository_impl.dart';
import 'package:smart_market/model/order/data/service/order.service_impl.dart';
import 'package:smart_market/model/order/domain/repository/order.repository.dart';
import 'package:smart_market/model/order/domain/service/order.service.dart';

void initOrderLocator(GetIt locator) {
  locator.registerLazySingleton<OrderService>(() => OrderServiceImpl());
  locator.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
}
