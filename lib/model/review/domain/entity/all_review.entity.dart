import 'package:smart_market/core/utils/split_host_url.dart';

class RequestAllReviews {
  final String align;
  final String column;

  const RequestAllReviews({
    required this.align,
    required this.column,
  });
}

class ResponseAllReview {
  final Review review;
  final Product product;

  const ResponseAllReview({
    required this.review,
    required this.product,
  });

  factory ResponseAllReview.fromJson(Map<String, dynamic> json) {
    return ResponseAllReview(
      review: Review.fromJson(json["review"]),
      product: Product.fromJson(json["product"]),
    );
  }
}

class Review {
  final String id;
  final int starRateScore;
  final String createdAt;

  const Review({
    required this.id,
    required this.starRateScore,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["id"],
      starRateScore: json["starRateScore"],
      createdAt: json["createdAt"],
    );
  }
}

class Product {
  final String id;
  final String name;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
    );
  }
}
