import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';

abstract interface class ProductRepository {
  Future<List<AllProduct>> fetchAllProducts();
  Future<DetailProduct> fetchDetailProduct(String productId);
}
