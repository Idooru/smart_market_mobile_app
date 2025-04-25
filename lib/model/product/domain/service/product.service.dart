import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';

abstract interface class ProductService {
  Future<List<AllProduct>> getAllProduct([SearchAllProduct? args]);
  Future<DetailProduct> getDetailProduct(String productId);
  Future<List<String>> getProductAutocomplete(String name);
}
