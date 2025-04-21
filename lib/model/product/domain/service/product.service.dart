import 'package:flutter/material.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';

abstract interface class ProductService {
  Future<void> insertAllProduct(BuildContext context);
  Future<DetailProduct> getDetailProduct(BuildContext context, String productId);
}
