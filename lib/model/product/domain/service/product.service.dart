import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';

abstract interface class ProductService {
  Future<List<AllProduct>> getAllProduct();
  Future<DetailProduct> getDetailProduct(String productId);
}
