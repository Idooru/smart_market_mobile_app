class AllProduct {
  final String id;
  final String name;
  final int price;
  final String category;
  final DateTime createdAt;
  final List<String> imageUrls;
  final double averageScore;
  final int reviewCount;

  const AllProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.createdAt,
    required this.imageUrls,
    required this.averageScore,
    required this.reviewCount,
  });

  factory AllProduct.fromJson(Map<String, dynamic> json) {
    return AllProduct(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      category: json["category"],
      createdAt: DateTime.parse(json["createdAt"]),
      imageUrls: List<String>.from(json["imageUrls"]),
      averageScore: double.parse(json["averageScore"]),
      reviewCount: json["reviewCount"],
    );
  }
}
