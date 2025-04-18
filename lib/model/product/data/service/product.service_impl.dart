import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product.provider.dart';

class ProductServiceImpl implements ProductService {
  final ProductRepository productRepository = locator<ProductRepository>();
  late ProductProvider productProvider;

  @override
  Future<void> insertAllProduct(BuildContext context) async {
    productProvider = context.watch<ProductProvider>();
    List<AllProduct> allProducts = await productRepository.fetchAllProducts();

    productProvider.setAllProducts(allProducts);
  }
}
