import 'package:flutter/material.dart';

abstract interface class ProductService {
  Future<void> insertAllProduct(BuildContext context);
}
