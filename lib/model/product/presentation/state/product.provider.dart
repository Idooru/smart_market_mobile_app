import 'package:flutter/material.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';

class ProductProvider extends ChangeNotifier {
  List<AllProduct> _allProducts = [];

  List<AllProduct> get allProducts => _allProducts;
  void setAllProducts(List<AllProduct> value) {
    _allProducts = value;
  }
}
