import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/order/domain/entities/create_order.entity.dart';
import 'package:smart_market/model/order/domain/repository/order.repository.dart';

import '../../../../core/utils/get_it_initializer.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/order");

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
