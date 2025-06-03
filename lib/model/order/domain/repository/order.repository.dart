import '../../../../core/common/data_state.dart';
import '../entities/create_order.entity.dart';

abstract interface class OrderRepository {
  Future<DataState<void>> createOrder(String accessToken, RequestCreateOrder args);
}
