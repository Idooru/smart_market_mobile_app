import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/core/widgets/common/custom_scrollbar.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

class ProductSearchFocusedWidget extends StatelessWidget {
  final ProductSearchProvider provider;
  final void Function(String keyword, ProductSearchProvider provider, void Function(RequestSearchProducts) callback) search;
  final void Function(RequestSearchProducts args) updateProductList;

  const ProductSearchFocusedWidget({
    super.key,
    required this.provider,
    required this.search,
    required this.updateProductList,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Expanded(
      child: ColoredBox(
        color: const Color.fromARGB(255, 235, 235, 235),
        child: provider.searchHistory.isNotEmpty
            ? CustomScrollbarWidget(
                scrollController: scrollController,
                childWidget: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      ...provider.searchHistory.asMap().entries.map(
                        (entry) {
                          int index = entry.key;
                          String history = entry.value;

                          return GestureDetector(
                            onTap: () => search(history, provider, updateProductList),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 252, 243),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey, // 밑줄 색
                                    width: 0.2, // 밑줄 두께
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(left: 15),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(history),
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
                                          provider.removeHistory(index);
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
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.clearHistory();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                          padding: const EdgeInsets.only(left: 15),
                          height: 40,
                          child: const Center(
                            child: Text("검색 기록 저장 끄기"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : provider.isSetHistory
                ? const Center(
                    child: Text("검색 기록이 비어있습니다."),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("검색 기록이 비어있습니다."),
                        TextButton(
                          onPressed: () {
                            provider.turnOnHistory();
                          },
                          child: const Text("검색 기록 저장 켜기"),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
