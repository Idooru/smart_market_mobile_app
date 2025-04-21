import 'package:dio/dio.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';

class ProductRepositoryImpl extends DioInitializer implements ProductRepository {
  @override
  Future<DataState<List<AllProduct>>> fetchAllProducts() async {
    try {
      Response response = await dio.get("$baseUrl/product/all");
      List<AllProduct> allProducts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => AllProduct.fromJson(data)).toList();
      return DataSuccess(data: allProducts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<DetailProduct>> fetchDetailProduct(String productId) async {
    try {
      Response response = await dio.get("$baseUrl/product/$productId");
      DetailProduct detailProduct = DetailProduct.fromJson(response.data["result"]);
      return DataSuccess(data: detailProduct);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
