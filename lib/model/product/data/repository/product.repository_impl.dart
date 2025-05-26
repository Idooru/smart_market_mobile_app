import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioInitializer _commonHttpClient = locator<DioInitializer>(instanceName: "common");
  final String _baseUrl = RequestUrl.getUrl("/product");

  @override
  Future<DataState<List<ResponseSearchProduct>>> fetchConditionalProducts(RequestConditionalProducts args) async {
    String url = "$_baseUrl/conditional?count=${args.count}&condition=${args.condition}";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      List<ResponseSearchProduct> conditionalProducts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseSearchProduct.fromJson(data)).toList();
      return DataSuccess(data: conditionalProducts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<ResponseSearchProduct>>> searchProduct(RequestSearchProducts args) async {
    String url = "$_baseUrl/search?mode=${translateRequestProductSearchMode(args.mode)}&keyword=${args.keyword}";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      List<ResponseSearchProduct> searchProducts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseSearchProduct.fromJson(data)).toList();
      return DataSuccess(data: searchProducts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseDetailProduct>> fetchDetailProduct(String productId) async {
    String url = "$_baseUrl/$productId";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      ResponseDetailProduct detailProduct = ResponseDetailProduct.fromJson(response.data["result"]);
      return DataSuccess(data: detailProduct);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<String>>> fetchProductAutocomplete(String name) async {
    name = name.isEmpty ? "_" : name;
    String url = "$_baseUrl/autocomplete/$name";
    Dio dio = _commonHttpClient.getClient();

    try {
      Response response = await dio.get(url);
      List<String> productNames = response.data["result"].cast<String>();
      return DataSuccess(data: productNames);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
