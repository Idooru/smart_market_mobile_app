class RequestCreateCart {
  final String productId;
  final int quantity;
  final int totalPrice;
  final bool isPayNow;

  const RequestCreateCart({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.isPayNow,
  });

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "totalPrice": totalPrice,
      "isPayNow": isPayNow,
    };
  }
}
