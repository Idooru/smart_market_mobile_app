import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';
import 'package:smart_market/model/cart/domain/entities/create_cart.entity.dart';
import 'package:smart_market/model/cart/domain/entities/modify_cart.entity.dart';

abstract interface class CartService {
  Future<ResponseCarts> fetchCarts(RequestCarts args);
  Future<void> createCart(RequestCreateCart args);
  Future<void> modifyCart(RequestModifyCart args);
  Future<void> deleteAllCarts();
  Future<void> deleteCart(String id);
}
