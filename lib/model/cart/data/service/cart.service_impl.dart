import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';

import '../../../../core/common/service.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/repository/cart.repository.dart';

class CartServiceImpl extends Service implements CartService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final CartRepository _cartRepository = locator<CartRepository>();

  @override
  Future<ResponseCarts> fetchCarts(RequestCarts args) async {
    String? accessToken = _db.getString("access-token");
    DataState<ResponseCarts> dataState = await _cartRepository.fetchCarts(accessToken!, args);
    if (dataState.exception != null) throwDioFailError(dataState);
    return dataState.data!;
  }
}
