class RequestModifyCart {
  final String cartId;
  final String productId;
  final int quantity;
  final int totalPrice;

  const RequestModifyCart({
    required this.cartId,
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
