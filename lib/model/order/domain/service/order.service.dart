import '../entities/order.entity.dart';

abstract interface class OrderService {
  Future<void> createOrder(RequestOrder args);
}
