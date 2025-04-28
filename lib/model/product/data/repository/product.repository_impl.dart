import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/repository/product.repository.dart';

class ProductRepositoryImpl extends DioInitializer implements ProductRepository {
  @override
  Future<DataState<List<ResponseSearchProduct>>> fetchAllProducts([RequestSearchProduct? args]) async {
    try {
      String url;

      if (args != null) {
        String validateNameQuery = args.name != null ? "name=${args.name}" : "";
        String validateCategoryQuery = args.category != "전체" ? "category=${args.category}" : "";
        url = "$baseUrl/product/all?align=${args.align}&column=${args.column}&$validateNameQuery&$validateCategoryQuery";
      } else {
        url = "$baseUrl/product/all";
      }

      debugPrint("url: $url");
      Response response = await dio.get(url);

      List<ResponseSearchProduct> allProducts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseSearchProduct.fromJson(data)).toList();
      return DataSuccess(data: allProducts);
    } on DioException catch (err) {
      debugPrint("response: ${err.message}");
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<ResponseSearchProduct>>> searchProduct(RequestSearchProducts args) async {
    try {
      String url =
          "$baseUrl/product/search?mode=${translateRequestProductSearchMode(args.mode)}&autoCompletes=${args.autoCompletes.isNotEmpty ? args.autoCompletes.reduce((value, element) => '$value, $element') : ""}&keyword=${args.keyword}";

      Response response = await dio.get(url);

      List<ResponseSearchProduct> searchProducts = List<Map<String, dynamic>>.from(response.data["result"]).map((data) => ResponseSearchProduct.fromJson(data)).toList();
      return DataSuccess(data: searchProducts);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseDetailProduct>> fetchDetailProduct(String productId) async {
    try {
      Response response = await dio.get("$baseUrl/product/$productId");
      ResponseDetailProduct detailProduct = ResponseDetailProduct.fromJson(response.data["result"]);
      return DataSuccess(data: detailProduct);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<String>>> fetchProductAutocomplete(String name) async {
    try {
      name = name.isEmpty ? "_" : name;
      Response response = await dio.get("$baseUrl/product/autocomplete/$name");
      List<String> productNames = response.data["result"].cast<String>();
      return DataSuccess(data: productNames);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
