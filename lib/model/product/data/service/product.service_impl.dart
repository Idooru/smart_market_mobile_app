import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';

class ProductServiceImpl implements ProductService {
  final ProductRepository productRepository = locator<ProductRepository>();

  @override
  Future<List<AllProduct>> getAllProduct([SearchAllProduct? args]) async {
    DataState<List<AllProduct>> dataState = await productRepository.fetchAllProducts(args);
    if (dataState.exception != null) throw DioFailError(message: dataState.exception.toString());
    return dataState.data!;
  }

  @override
  Future<DetailProduct> getDetailProduct(String productId) async {
    DataState<DetailProduct> dataState = await productRepository.fetchDetailProduct(productId);
    if (dataState.exception != null) throw DioFailError(message: dataState.exception.toString());
    return dataState.data!;
  }
}
