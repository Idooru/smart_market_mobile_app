class RequestCreateCart {
  final String productId;
  final int quantity;
  final int totalPrice;

  const RequestCreateCart({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "totalPrice": totalPrice,
    };
  }
}
