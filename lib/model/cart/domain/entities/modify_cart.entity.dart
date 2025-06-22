import 'package:smart_market/model/cart/domain/entities/create_cart.entity.dart';

class RequestModifyCart extends RequestCreateCart {
  final String cartId;

  const RequestModifyCart({
    required this.cartId,
    required super.productId,
    required super.quantity,
    required super.totalPrice,
    required super.isPayNow,
  });
}
