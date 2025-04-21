import 'package:flutter/material.dart';
import 'package:smart_market/model/product/presentation/routes/route.strategy.dart';

abstract class RouteStrategy {
  MaterialPageRoute route(RouteSettings settings);
}

final Map<String, RouteStrategy> routeStrategies = {
  "/all_product": AllProductRouteStrategy(),
  "/detail_product": DetailProductRouteStrategy(),
  "/review_video_player": ReviewVideoRouteStrategy(),
};
