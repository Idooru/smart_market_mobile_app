import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_item.widget.dart';

class ProductSearchResultWidget extends StatelessWidget {
  final ProductService productService = locator<ProductService>();

  final ProductSearchProvider provider;
  final Future<List<ResponseSearchProduct>> getAllProductFuture;
  final void Function() reconnectCallback;

  ProductSearchResultWidget({
    super.key,
    required this.provider,
    required this.getAllProductFuture,
    required this.reconnectCallback,
  });

  Widget getNoneProduct(String keyword) {
    if (keyword.isEmpty) keyword = '""';
    return Column(
      children: [
        const SizedBox(height: 100),
        Text("$keyword(와)과 상품 필터링 조건에"),
        const Text(" 해당하는 상품을 찾을 수 없습니다."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: getAllProductFuture,
        builder: (BuildContext context, AsyncSnapshot<List<ResponseSearchProduct>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                const SizedBox(height: 100),
                LoadingHandlerWidget(title: "${provider.keyword}로 검색한 결과 불러오기.."),
              ],
            );
          } else if (snapshot.hasError) {
            DioFailError error = snapshot.error as DioFailError;
            if (error.message.contains("Timeout") || error.message.contains('Socket')) {
              return Column(
                children: [
                  const SizedBox(height: 100),
                  NetworkErrorHandlerWidget(reconnectCallback: reconnectCallback),
                ],
              );
            } else {
              return const Column(
                children: [
                  SizedBox(height: 100),
                  InternalServerErrorHandlerWidget(),
                ],
              );
            }
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            if (products.isEmpty) {
              return getNoneProduct(provider.keyword);
            }
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // 상품 갯수 정보 표시
                Container(
                  color: Colors.white,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(180, 240, 240, 240),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(width: 10),
                        Text("총 ${products.length}개의 상품 목록을 가져옵니다."),
                      ],
                    ),
                  ),
                ),
                // 실제 상품 목록
                ...products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final isLast = index == products.length - 1;
                  return ProductItemWidget(
                    currentAllProduct: product,
                    margin: isLast ? const EdgeInsets.fromLTRB(13, 13, 13, 10) : const EdgeInsets.fromLTRB(13, 13, 13, 0),
                  );
                }),
              ],
            );
          } else {
            return getNoneProduct(provider.keyword);
          }
        },
      ),
    );
  }
}
