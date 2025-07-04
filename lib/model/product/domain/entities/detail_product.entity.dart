import 'package:smart_market/core/utils/split_host_url.dart';

class ResponseDetailProduct {
  final Product product;
  final List<Review> reviews;

  const ResponseDetailProduct({
    required this.product,
    required this.reviews,
  });

  factory ResponseDetailProduct.fromJson(Map<String, dynamic> json) {
    return ResponseDetailProduct(
      product: Product.fromJson(json["product"]),
      reviews: (json["reviews"] as List).map((e) => Review.fromJson(e)).toList(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final int price;
  final String origin;
  final String category;
  final String description;
  final List<String> imageUrls;
  final double averageScore;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.origin,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.averageScore,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      origin: json["origin"],
      category: json["category"],
      description: json["description"],
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
      averageScore: double.parse(json["averageScore"]),
    );
  }
}

class Review {
  final String id;
  final String content;
  final double starRateScore;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final String createdAt;
  final String nickName;

  const Review({
    required this.id,
    required this.content,
    required this.starRateScore,
    required this.imageUrls,
    required this.videoUrls,
    required this.createdAt,
    required this.nickName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["id"],
      content: json["content"],
      starRateScore: double.parse(json["starRateScore"]),
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
      videoUrls: List<String>.from(json["videoUrls"]).map(splitHostUrl).toList(),
      createdAt: json["createdAt"],
      nickName: json["nickName"],
    );
  }
}
