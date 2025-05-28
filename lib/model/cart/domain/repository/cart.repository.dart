import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';
import 'package:smart_market/model/cart/domain/entities/modify_cart.entity.dart';

import '../../../../core/common/data_state.dart';

abstract interface class CartRepository {
  Future<DataState<ResponseCarts>> fetchCarts(String accessToken, RequestCarts args);
  Future<DataState<void>> modifyCart(String accessToken, RequestModifyCart args);
  Future<DataState<void>> deleteAllCarts(String accessToken);
  Future<DataState<void>> deleteCart(String accessToken, String id);
}
