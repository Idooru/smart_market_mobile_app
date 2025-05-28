import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/utils/throw_network_error.dart';
import '../../domain/entities/modify_cart.entity.dart';
import '../../domain/repository/cart.repository.dart';

class CartServiceImpl implements CartService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final CartRepository _cartRepository = locator<CartRepository>();

  @override
  Future<ResponseCarts> fetchCarts(RequestCarts args) async {
    String? accessToken = _db.getString("access-token");
    DataState<ResponseCarts> dataState = await _cartRepository.fetchCarts(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> modifyCart(RequestModifyCart args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _cartRepository.modifyCart(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> deleteAllCarts() async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _cartRepository.deleteAllCarts(accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<void> deleteCart(String id) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _cartRepository.deleteCart(accessToken!, id);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
