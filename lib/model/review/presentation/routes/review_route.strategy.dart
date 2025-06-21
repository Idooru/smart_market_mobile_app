import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/review/presentation/pages/all_reviews.page.dart';
import 'package:smart_market/model/review/presentation/pages/create_review.page.dart';

final Map<String, RouteStrategy> reviewRouteStrategies = {
  "/all_reviews": AllReviewsStrategy(),
  "/create_review": CreateReviewStrategy(),
};

class AllReviewsStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const AllReviewsPage(),
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
    );
  }
}
