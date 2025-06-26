import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';
import 'package:smart_market/model/product/presentation/pages/review_video_player.page.dart';

final Map<String, RouteStrategy> productRouteStrategies = {
  "/detail_product": DetailProductRouteStrategy(),
  "/review_video_player": ReviewVideoRouteStrategy(),
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

class ReviewVideoRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as FileSource;
    return MaterialPageRoute(
      builder: (context) => ReviewVideoPlayerPage(
        fileSource: args,
      ),
      settings: settings,
    );
  }
}
