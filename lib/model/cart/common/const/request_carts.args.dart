import '../../domain/entities/cart.entity.dart';

class RequestCartsArgs {
  static RequestCarts _args = const RequestCarts(align: "DESC", column: "createdAt");
  static RequestCarts get args => _args;

  static void setArgs(RequestCarts args) {
    _args = args;
  }
}
