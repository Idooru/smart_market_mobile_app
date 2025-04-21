import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product.provider.dart';

class ProductServiceImpl implements ProductService {
  final ProductRepository productRepository = locator<ProductRepository>();
  late ProductProvider productProvider;

  @override
  Future<List<AllProduct>> getAllProduct(BuildContext context) async {
    productProvider = context.watch<ProductProvider>();
    return productRepository.fetchAllProducts();
  }

  @override
  Future<DetailProduct> getDetailProduct(BuildContext context, String productId) async {
    productProvider = context.watch<ProductProvider>();
    return productRepository.fetchDetailProduct(productId);
  }
}
