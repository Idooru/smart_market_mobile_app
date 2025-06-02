import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/order/presentation/pages/create_order.page.dart';

final Map<String, RouteStrategy> orderRouteStrategies = {
  "/create_order": CreateOrderStrategy(),
};

class CreateOrderStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CreateOrderPageArgs;
    return MaterialPageRoute(
      builder: (context) => CreateOrderPage(
        address: args.address,
        updateCallback: args.updateCallback,
      ),
      settings: settings,
    );
  }
}
