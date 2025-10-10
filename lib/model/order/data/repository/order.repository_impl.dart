import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/order/domain/entities/create_order.entity.dart';
import 'package:smart_market/model/order/domain/repository/order.repository.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/entities/order.entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/order");

  @override
  Future<DataState<List<ResponseOrders>>> fetchOrders(String accessToken, RequestOrders args) async {
    String url = "$_baseUrl/all?align=${args.align}&column=${args.column}${args.deliveryOption != "none" ? "&option=${args.deliveryOption}" : ""}"
        "${args.transactionStatus != "none" ? "&transactionStatus=${args.transactionStatus}" : ""}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      List<ResponseOrders> responseOrders = List<Map<String, dynamic>>.from(response.data["result"]).map((e) => ResponseOrders.fromJson(e)).toList();
      return DataSuccess(data: responseOrders);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> createOrder(String accessToken, RequestCreateOrder args) async {
    String url = "$_baseUrl/";
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
  Future<DataState<void>> cancelOrder(String accessToken, String orderId) async {
    String url = "$_baseUrl/cancel/orderId/$orderId";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.patch(url);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
