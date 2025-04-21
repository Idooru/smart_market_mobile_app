import 'package:dio/dio.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';

class ProductRepositoryImpl extends DioInitializer implements ProductRepository {
  @override
  Future<List<AllProduct>> fetchAllProducts() async {
    Response response = await dio.get("$baseUrl/product/all");
    return List<Map<String, dynamic>>.from(response.data["result"]).map((data) => AllProduct.fromJson(data)).toList();
  }

  @override
  Future<DetailProduct> fetchDetailProduct(String productId) async {
    Response response = await dio.get("$baseUrl/product/$productId");
    return DetailProduct.fromJson(response.data["result"]);
  }
}
