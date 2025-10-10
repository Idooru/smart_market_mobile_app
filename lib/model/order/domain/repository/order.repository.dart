import 'package:smart_market/model/order/domain/entities/order.entity.dart';

import '../../../../core/common/data_state.dart';
import '../entities/create_order.entity.dart';

abstract interface class OrderRepository {
  Future<DataState<List<ResponseOrders>>> fetchOrders(String accessToken, RequestOrders args);
  Future<DataState<void>> createOrder(String accessToken, RequestCreateOrder args);
  Future<DataState<void>> cancelOrder(String accessToken, String orderId);
}
