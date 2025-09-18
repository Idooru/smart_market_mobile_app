import '../../../../core/utils/split_host_url.dart';

class RequestCarts {
  final String align;
  final String column;

  const RequestCarts({
    required this.align,
    required this.column,
  });
}

class ResponseCarts {
  final List<Cart> items;
  final int totalPrice;

  const ResponseCarts({
    required this.items,
    required this.totalPrice,
  });

  factory ResponseCarts.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return const ResponseCarts(items: [], totalPrice: 0);
    }

    return ResponseCarts(
      items: json.map((e) => Cart.fromJson(e)).toList(),
      totalPrice: json.map((e) => Cart.fromJson(e)).map((cart) => cart.totalPrice).reduce((acc, cur) => acc += cur),
    );
  }
}

class Cart {
  final String id;
  final int quantity;
  final int totalPrice;
  final String createdAt;
  final Product product;
  final bool isPayNow;

  const Cart({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.product,
    required this.isPayNow,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json["id"],
      quantity: json["quantity"],
      totalPrice: json["totalPrice"],
      createdAt: json["createdAt"],
      product: Product.fromJson(json["product"]),
      isPayNow: json["isPayNow"],
    );
  }
}

class Product {
  final String id;
  final String name;
  final int price;
  final String category;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      category: json["category"],
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
    );
  }
}
