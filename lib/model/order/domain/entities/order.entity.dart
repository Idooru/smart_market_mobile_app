class RequestOrder {
  final String deliveryOption;
  final String deliveryAddress;

  const RequestOrder({
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
