import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';

abstract interface class CartService {
  Future<ResponseCarts> fetchCarts(RequestCarts args);
}
