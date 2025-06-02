import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/throw_network_error.dart';
import 'package:smart_market/model/order/domain/entities/order.entity.dart';
import 'package:smart_market/model/order/domain/repository/order.repository.dart';
import 'package:smart_market/model/order/domain/service/order.service.dart';

import '../../../../core/common/data_state.dart';

class OrderServiceImpl implements OrderService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final OrderRepository _orderRepository = locator<OrderRepository>();

  @override
  Future<void> createOrder(RequestOrder args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _orderRepository.createOrder(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
