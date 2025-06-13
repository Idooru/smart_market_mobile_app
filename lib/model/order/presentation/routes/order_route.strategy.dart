import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/order/presentation/pages/complete_create_order.page.dart';
import 'package:smart_market/model/order/presentation/pages/create_order.page.dart';
import 'package:smart_market/model/order/presentation/pages/display_payment.page.dart';

final Map<String, RouteStrategy> orderRouteStrategies = {
  "/create_order": CreateOrderStrategy(),
  "/display_payment": DisplayPaymentStrategy(),
  "/complete_create_order": CompleteCreateOrderStrategy(),
};

class CreateOrderStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CreateOrderPageArgs;
    return MaterialPageRoute(
      builder: (context) => CreateOrderPage(
        address: args.address,
        updateCallback: args.updateCallback,
        isCreateCart: args.isCreateCart,
        backRoute: args.backRoute,
      ),
      settings: settings,
    );
  }
}

class DisplayPaymentStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as DisplayPaymentPageArgs;
    return MaterialPageRoute(
      builder: (context) => DisplayPaymentPage(
        responseOrders: args.responseOrders,
      ),
      settings: settings,
    );
  }
}

class CompleteCreateOrderStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CompleteCreateOrderPageArgs;
    return MaterialPageRoute(
      builder: (context) => CompleteCreateOrderPage(
        carts: args.carts,
        requestCreateOrderArgs: args.args,
        isCreateCart: args.isCreateCart,
        updateCallback: args.updateCallback,
        backRoute: args.backRoute,
      ),
    );
  }
}
