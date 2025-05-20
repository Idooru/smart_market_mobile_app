import 'package:flutter/material.dart';
import 'package:smart_market/model/product/presentation/routes/route.strategy.dart';
import 'package:smart_market/model/user/presentation/routes/route.strategy.dart';

abstract class RouteStrategy {
  MaterialPageRoute route(RouteSettings settings);
}

final Map<String, RouteStrategy> routeStrategies = {
  ...productRouteStrategies,
  ...userRouteStrategies,
};
