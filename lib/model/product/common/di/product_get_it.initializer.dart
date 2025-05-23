import 'package:get_it/get_it.dart';
import 'package:smart_market/model/product/data/repository/product.repository_impl.dart';
import 'package:smart_market/model/product/data/service/product.service_impl.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';

void initProductLocator(GetIt locator) {
  locator.registerLazySingleton<ProductService>(() => ProductServiceImpl());
  locator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
}
