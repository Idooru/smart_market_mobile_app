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
  Future<DataState<ResponseOrders>> fetchOrders(String accessToken, RequestOrders args) async {
    String url = "$_baseUrl/?align=${args.align}&column=${args.column}&option=${args.deliveryOption}&transactionStatus=${args.transactionStatus}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      ResponseOrders responseOrders = ResponseOrders.fromJson(response.data["result"]);
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
}
