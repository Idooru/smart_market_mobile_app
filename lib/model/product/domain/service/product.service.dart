import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';

abstract interface class ProductService {
  Future<List<ResponseSearchProduct>> getAllProduct([RequestSearchProduct? args]);
  Future<List<ResponseSearchProduct>> getSearchProduct(RequestSearchProducts args);
  Future<ResponseDetailProduct> getDetailProduct(String productId);
  Future<List<String>> getProductAutocomplete(String name);
}
