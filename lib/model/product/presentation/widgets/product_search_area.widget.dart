import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/filter.widget.dart';

class ProductSearchAreaWidget extends StatefulWidget {
  final void Function(SearchAllProduct) searchCallback;
  final ProductSearchProvider provider;

  const ProductSearchAreaWidget({
    super.key,
    required this.searchCallback,
    required this.provider,
  });

  @override
  State<ProductSearchAreaWidget> createState() => _ProductSearchAreaWidgetState();
}

class _ProductSearchAreaWidgetState extends State<ProductSearchAreaWidget> {
  final ProductService productService = locator<ProductService>();

  late Future<List<String>> _getProductAutoComplete;

  Widget getSearchArea(Widget widget) {
    return Container(
      height: 205,
      color: const Color.fromARGB(255, 235, 235, 235),
      child: widget,
    );
  }

  void search(String search, ProductSearchProvider provider) {
    provider.appendHistory(search);

    SearchAllProduct searchAllProduct = SearchAllProduct(
      align: filterMap["select-algin"] ?? "DESC",
      column: filterMap["select-column"] ?? "createdAt",
      category: filterMap["select-category"] ?? "전체",
      name: search,
    );

    provider.setSearchMode(SearchMode.none);
    widget.searchCallback(searchAllProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSearchProvider>(
      builder: (BuildContext context, ProductSearchProvider provider, Widget? child) {
        if (widget.provider.searchMode == SearchMode.focused) {
          ScrollController scrollController = ScrollController();
          return getSearchArea(
            SizedBox(
              width: double.infinity,
              child: widget.provider.searchHistory.isNotEmpty
                  ? Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: widget.provider.searchHistory.asMap().entries.map((entry) {
                            int index = entry.key;
                            String history = entry.value;

                            return Container(
                              padding: const EdgeInsets.only(left: 15),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => search(history, provider),
                                    child: Text(history),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        parseDate(DateTime.now()),
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 93, 93, 93),
                                          fontSize: 12,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          widget.provider.removeHistory(index);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          size: 22,
                                          color: Colors.red[900],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text("검색 기록이 비어있습니다."),
                    ),
            ),
          );
        } // 자동 완성 표시
        else if (widget.provider.searchMode == SearchMode.searching) {
          _getProductAutoComplete = productService.getProductAutocomplete(widget.provider.search);
          return getSearchArea(
            FutureBuilder(
              future: _getProductAutoComplete,
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingHandlerWidget(title: "상품 이름 자동완성 중..");
                } else if (snapshot.hasError) {
                  DioFailError error = snapshot.error as DioFailError;
                  if (error.message.contains("Timeout") || error.message.contains('Socket')) {
                    return NetworkErrorHandlerWidget(reconnectCallback: () {
                      setState(() {
                        _getProductAutoComplete = productService.getProductAutocomplete(widget.provider.search);
                      });
                    });
                  } else {
                    return const InternalServerErrorHandlerWidget();
                  }
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  ScrollController scrollController = ScrollController();

                  return SizedBox(
                    width: double.infinity,
                    child: data.isNotEmpty
                        ? Scrollbar(
                            controller: scrollController,
                            thickness: 20,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: data
                                    .map(
                                      (productName) => GestureDetector(
                                        onTap: () => search(productName, provider),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(productName),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("해당 이름의 상품이 존재하지 않습니다."),
                          ),
                  );
                } else {
                  return const Center(child: Text('데이터가 없습니다.'));
                }
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
    // 검색 기록 표시
  }
}
