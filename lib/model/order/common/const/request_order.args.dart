import '../../domain/entities/order.entity.dart';

class RequestOrdersArgs {
  static RequestOrders _args = const RequestOrders(
    align: "DESC",
    column: "createdAt",
    deliveryOption: "none",
    transactionStatus: "none",
  );
  static RequestOrders get args => _args;

  static setArgs(RequestOrders args) {
    _args = args;
  }
}
