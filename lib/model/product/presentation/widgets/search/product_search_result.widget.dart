import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_grid_item.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_list_item.widget.dart';

class ProductSearchResultWidget extends StatelessWidget {
  final void Function() reconnectCallback;
  final ViewMode viewMode;

  const ProductSearchResultWidget({
    super.key,
    required this.viewMode,
    required this.reconnectCallback,
  });

  Widget getProductCountContainer(List<ResponseSearchProduct> products) {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductSearchProvider, ProductFilteredProvider>(
      builder: (BuildContext context, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, Widget? child) {
        return SliverToBoxAdapter(
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: searchProvider.fail == SearchProductFail.socketException ? 3000 : 300)),
            builder: (context, snapshot) {
              List<ResponseSearchProduct> products = filteredProvider.isFiltered ? filteredProvider.products : searchProvider.products;
              if (snapshot.connectionState != ConnectionState.done) {
                return Column(
                  children: [
                    const SizedBox(height: 100),
                    LoadingHandlerWidget(title: "${searchProvider.keyword}${filteredProvider.isFiltered ? "에서 정렬" : "(으)로 검색"} 한 결과 불러오기.."),
                  ],
                );
              } else {
                if (searchProvider.fail == SearchProductFail.socketException) {
                  return Column(
                    children: [
                      const SizedBox(height: 100),
                      NetworkErrorHandlerWidget(reconnectCallback: reconnectCallback),
                    ],
                  );
                } else if (searchProvider.fail == SearchProductFail.internalServerException) {
                  return const Column(
                    children: [
                      SizedBox(height: 100),
                      InternalServerErrorHandlerWidget(),
                    ],
                  );
                } else if (products.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(height: 100),
                      Text("검색 결과가 없습니다."),
                    ],
                  );
                } else {
                  if (viewMode == ViewMode.list) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // 상품 갯수 정보 표시
                        getProductCountContainer(products),
                        // 실제 상품 목록
                        ...products.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final product = entry.value;
                            final isLast = index == products.length - 1;
                            return ProductListItemWidget(
                              product: product,
                              margin: isLast ? const EdgeInsets.fromLTRB(13, 13, 13, 10) : const EdgeInsets.fromLTRB(13, 13, 13, 0),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        getProductCountContainer(products),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: LayoutBuilder(builder: (context, constraints) {
                            // 가로 한 줄에 2개의 아이템이 들어가므로
                            final width = (constraints.maxWidth - 1.0) / 2;
                            // 여기서 높이는 원하는 위젯의 예상 높이로 계산 (예: 이미지 비율 + 텍스트 등 합산)
                            final height = width * 1.9; // 비율 조정 예시
                            final aspectRatio = width / height;
                            return GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 1.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: aspectRatio,
                              ),
                              children: products.map((product) => ProductGridItemWidget(product: product)).toList(),
                            );
                          }),
                        ),
                      ],
                    );
                  }
                }
              }
            },
          ),
        );
      },
    );
  }
}
