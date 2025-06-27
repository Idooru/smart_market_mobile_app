import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/review/presentation/pages/all_reviews.page.dart';
import 'package:smart_market/model/review/presentation/pages/create_review.page.dart';
import 'package:smart_market/model/review/presentation/pages/detail_review.page.dart';

import '../../../media/domain/entities/file_source.entity.dart';
import '../pages/review_video_player.page.dart';

final Map<String, RouteStrategy> reviewRouteStrategies = {
  "/all_reviews": AllReviewsStrategy(),
  "/create_review": CreateReviewStrategy(),
  "/detail_review": DetailReviewStrategy(),
  "/review_video_player": ReviewVideoRouteStrategy(),
};

class AllReviewsStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const AllReviewsPage(),
      settings: settings,
    );
  }
}

class CreateReviewStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CreateReviewPageArgs;
    return MaterialPageRoute(
      builder: (context) => CreateReviewPage(
        products: args.products,
        backRoute: args.backRoute,
      ),
      settings: settings,
    );
  }
}

class DetailReviewStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as DetailReviewPageArgs;
    return MaterialPageRoute(
      builder: (context) => DetailReviewPage(
        reviewId: args.reviewId,
        productId: args.productId,
        productName: args.productName,
        updateCallback: args.updateCallback,
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
