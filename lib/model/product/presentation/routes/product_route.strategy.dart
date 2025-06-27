import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';

final Map<String, RouteStrategy> productRouteStrategies = {
  "/detail_product": DetailProductRouteStrategy(),
};

class DetailProductRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as DetailProductPageArgs;
    return MaterialPageRoute(
      builder: (context) => DetailProductPage(
        productId: args.productId,
      ),
      settings: settings,
    );
  }
}
