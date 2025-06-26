import 'package:flutter/material.dart';
import 'package:smart_market/model/account/presentation/routes/account_route.strategy.dart';
import 'package:smart_market/model/media/presentation/routes/media_route.strategy.dart';
import 'package:smart_market/model/order/presentation/routes/order_route.strategy.dart';
import 'package:smart_market/model/product/presentation/routes/product_route.strategy.dart';
import 'package:smart_market/model/review/presentation/routes/review_route.strategy.dart';
import 'package:smart_market/model/user/presentation/routes/user_route.strategy.dart';

abstract class RouteStrategy {
  MaterialPageRoute route(RouteSettings settings);
}

final Map<String, RouteStrategy> routeStrategies = {
  ...productRouteStrategies,
  ...userRouteStrategies,
  ...accountRouteStrategies,
  ...orderRouteStrategies,
  ...reviewRouteStrategies,
  ...mediaRouteStrategies,
};
