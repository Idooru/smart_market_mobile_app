class RequestCreateOrder {
  final String deliveryOption;
  final String deliveryAddress;

  const RequestCreateOrder({
    required this.deliveryOption,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "deliveryOption": deliveryOption,
      "deliveryAddress": deliveryAddress,
    };
  }
}
