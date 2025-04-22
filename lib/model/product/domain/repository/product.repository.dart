import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';

abstract interface class ProductRepository {
  Future<DataState<List<AllProduct>>> fetchAllProducts([SearchAllProduct? args]);
  Future<DataState<DetailProduct>> fetchDetailProduct(String productId);
}
