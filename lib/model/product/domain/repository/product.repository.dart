import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';

abstract interface class ProductRepository {
  // Future<DataState<List<ResponseSearchProduct>>> fetchAllProducts([RequestConditionalProducts? args]);
  Future<DataState<List<ResponseSearchProduct>>> fetchConditionalProducts(RequestConditionalProducts args);
  Future<DataState<List<ResponseSearchProduct>>> searchProduct(RequestSearchProducts args);
  Future<DataState<ResponseDetailProduct>> fetchDetailProduct(String productId);
  Future<DataState<List<String>>> fetchProductAutocomplete(String name);
}
