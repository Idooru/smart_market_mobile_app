import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/entities/create_cart.entity.dart';
import '../../domain/entities/modify_cart.entity.dart';
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

  @override
  Future<DataState<void>> createCart(String accessToken, RequestCreateCart args) async {
    String url = "$_baseUrl/product/${args.productId}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.post(url, data: args.toJson());

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> modifyCart(String accessToken, RequestModifyCart args) async {
    String url = "$_baseUrl/${args.cartId}/product/${args.productId}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.put(url, data: args.toJson());

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deleteAllCarts(String accessToken) async {
    String url = "$_baseUrl/";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deleteCart(String accessToken, String id) async {
    String url = "$_baseUrl/$id";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
