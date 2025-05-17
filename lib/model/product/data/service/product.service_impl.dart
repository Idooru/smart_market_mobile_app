import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';

import '../../../../core/common/service.dart';

class ProductServiceImpl extends Service implements ProductService {
  final ProductRepository productRepository = locator<ProductRepository>();

  @override
  Future<List<ResponseSearchProduct>> getConditionalProducts(RequestConditionalProducts args) async {
    DataState<List<ResponseSearchProduct>> dataState = await productRepository.fetchConditionalProducts(args);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<List<ResponseSearchProduct>> getSearchProduct(RequestSearchProducts args) async {
    DataState<List<ResponseSearchProduct>> dataState = await productRepository.searchProduct(args);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseDetailProduct> getDetailProduct(String productId) async {
    DataState<ResponseDetailProduct> dataState = await productRepository.fetchDetailProduct(productId);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }

  @override
  Future<List<String>> getProductAutocomplete(String name) async {
    DataState<List<String>> dataState = await productRepository.fetchProductAutocomplete(name);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }
}
