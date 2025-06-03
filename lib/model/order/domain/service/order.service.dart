import '../entities/create_order.entity.dart';

abstract interface class OrderService {
  Future<void> createOrder(RequestCreateOrder args);
}
