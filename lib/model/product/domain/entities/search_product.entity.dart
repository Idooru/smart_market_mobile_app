import 'package:smart_market/core/utils/split_host_url.dart';

enum RequestProductSearchMode {
  manual,
  category,
}

String translateRequestProductSearchMode(RequestProductSearchMode searchMode) {
  if (searchMode == RequestProductSearchMode.manual) {
    return "manual";
  }
  return "category";
}

class RequestSearchProduct {
  final String align;
  final String column;
  final String category;
  final String? name;

  const RequestSearchProduct({
    required this.align,
    required this.column,
    required this.category,
    this.name,
  });
}

class RequestSearchProducts {
  final RequestProductSearchMode mode;
  final List<String> autoCompletes;
  final String keyword;

  const RequestSearchProducts({
    required this.mode,
    required this.autoCompletes,
    required this.keyword,
  });
}

class ResponseSearchProduct {
  final String id;
  final String name;
  final int price;
  final String category;
  final DateTime createdAt;
  final List<String> imageUrls;
  final double averageScore;
  final int reviewCount;

  const ResponseSearchProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.createdAt,
    required this.imageUrls,
    required this.averageScore,
    required this.reviewCount,
  });

  factory ResponseSearchProduct.fromJson(Map<String, dynamic> json) {
    return ResponseSearchProduct(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      category: json["category"],
      createdAt: DateTime.parse(json["createdAt"]),
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
      averageScore: double.parse(json["averageScore"]),
      reviewCount: json["reviewCount"],
    );
  }
}
