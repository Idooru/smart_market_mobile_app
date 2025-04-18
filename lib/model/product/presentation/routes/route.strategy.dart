import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';

class AllProductRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    throw UnimplementedError();
  }
}

class DetailProductRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as DetailProductPageArgs;
    return MaterialPageRoute(
      builder: (context) => DetailProductPage(
        productId: args.productId,
        productName: args.productName,
      ),
      settings: settings,
    );
  }
}
