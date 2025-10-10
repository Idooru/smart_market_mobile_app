import 'package:smart_market/model/order/domain/entities/order.entity.dart';

import '../entities/create_order.entity.dart';

abstract interface class OrderService {
  Future<List<ResponseOrders>> fetchOrders(RequestOrders args);
  Future<void> createOrder(RequestCreateOrder args);
  Future<void> cancelOrder(String orderId);
}
