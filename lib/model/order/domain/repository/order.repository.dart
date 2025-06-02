import '../../../../core/common/data_state.dart';
import '../entities/order.entity.dart';

abstract interface class OrderRepository {
  Future<DataState<void>> createOrder(String accessToken, RequestOrder args);
}
