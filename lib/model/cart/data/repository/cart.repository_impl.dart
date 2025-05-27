import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/repository/cart.repository.dart';

class CartRepositoryImpl implements CartRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/cart");

  @override
  Future<DataState<ResponseCarts>> fetchCarts(String accessToken, RequestCarts args) async {
    String url = "$_baseUrl/all?align=${args.align}&column=${args.column}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      ResponseCarts carts = ResponseCarts.fromJson(response.data["result"]);
      return DataSuccess(data: carts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
