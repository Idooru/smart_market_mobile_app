import '../../../cart/domain/entities/cart.entity.dart';

class RequestOrders {
  final String align;
  final String column;
  final String deliveryOption;
  final String transactionStatus;

  const RequestOrders({
    required this.align,
    required this.column,
    required this.deliveryOption,
    required this.transactionStatus,
  });
}

class ResponseOrders {
  final Order order;
  final List<Payment> payments;

  const ResponseOrders({
    required this.order,
    required this.payments,
  });

  factory ResponseOrders.fromJson(Map<String, dynamic> json) {
    return ResponseOrders(
      order: Order.fromJson(json["order"]),
      payments: (json["payment"] as List).map((e) => Payment.fromJson(e)).toList(),
    );
  }
}

class Order {
  final String id;
  final String deliveryOption;
  final String deliveryAddress;
  final String transactionStatus;
  final int surtaxPrice;
  final int totalPrice;
  final String createdAt;

  const Order({
    required this.id,
    required this.deliveryOption,
    required this.deliveryAddress,
    required this.transactionStatus,
    required this.surtaxPrice,
    required this.totalPrice,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      deliveryOption: json["deliveryOption"],
      deliveryAddress: json["deliveryAddress"],
      transactionStatus: json["transactionStatus"],
      surtaxPrice: json["surtaxPrice"],
      totalPrice: json["totalPrice"],
      createdAt: json["createdAt"],
    );
  }
}

class Payment {
  final String id;
  final int quantity;
  final int totalPrice;
  final Product product;

  const Payment({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.product,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["id"],
      quantity: json["quantity"],
      totalPrice: json["totalPrice"],
      product: Product.fromJson(json["product"]),
    );
  }
}
