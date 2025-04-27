import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/core/widgets/common/custom_scrollbar.widget.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/main/presentation/page/app_main.page.dart';
import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_filter.dialog.dart';
import 'package:smart_market/model/product/presentation/widgets/product_item.widget.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ProductService productService = locator<ProductService>();
  final FocusNode focusNode = FocusNode();
  Future<List<AllProduct>>? _getAllProductFuture;
  late Future<List<String>> _getProductAutoCompleteFuture;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductSearchProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      provider.setSearchMode(SearchMode.focused);
    });

    focusNode.addListener(() {
      if (!mounted) return;
      if (focusNode.hasFocus && provider.keyword.isNotEmpty) {
        provider.setSearchMode(SearchMode.searching);
      } else if (focusNode.hasFocus) {
        provider.setSearchMode(SearchMode.focused);
      } else {
        provider.setSearchMode(SearchMode.none);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  Widget getSearchArea(Widget widget) {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 235, 235, 235),
        child: widget,
      ),
    );
  }

  Widget getNoneProduct(String keyword) {
    if (keyword.isEmpty) keyword = '""';
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$keyword(와)과 상품 필터링 조건에"),
          const Text(" 해당하는 상품을 찾을 수 없습니다."),
        ],
      ),
    );
  }

  void updateProductList(SearchAllProduct args) {
    setState(() {
      _getAllProductFuture = productService.getAllProduct(args);
    });
  }

  void pressCancelButton(ProductSearchProvider provider) {
    provider.setKeyword("");
    provider.setSearchMode(SearchMode.focused);
    focusNode.requestFocus();
  }

  void search(String keyword, ProductSearchProvider provider, void Function(SearchAllProduct) callback) {
    if (keyword.isEmpty) return;

    SearchAllProduct searchAllProduct = SearchAllProduct(
      align: filterMap["select-algin"] ?? "DESC",
      column: filterMap["select-column"] ?? "createdAt",
      category: filterMap["select-category"] ?? "전체",
      name: keyword,
    );

    provider.appendHistory(keyword);
    provider.setKeyword(keyword);
    provider.setSearchMode(SearchMode.none);
    callback(searchAllProduct);
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSearchProvider>(
      builder: (BuildContext context, ProductSearchProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Search"),
            centerTitle: false,
            backgroundColor: Colors.blueGrey[300]!,
            actions: provider.searchMode == SearchMode.none && provider.keyword.isNotEmpty
                ? [
                    IconButton(
                      onPressed: () => ProductFilterDialog.show(context, updateProductList),
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.view_agenda_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ]
                : [],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                final state = context.findAncestorStateOfType<AppMainPageState>();
                state?.tapBottomNavigator(0); // AllProductPage
              },
            ),
          ),
          body: Column(
            children: [
              Container(
                color: Colors.blueGrey[100],
                height: 45,
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: provider.controller,
                        textInputAction: TextInputAction.search,
                        focusNode: focusNode,
                        onChanged: (String keyword) {
                          if (keyword.isEmpty) {
                            provider.setSearchMode(SearchMode.focused);
                          } else {
                            provider.setSearchMode(SearchMode.searching);
                          }
                          provider.setKeyword(keyword);
                        },
                        onSubmitted: (String text) => search(text, provider, updateProductList),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: "상품 이름을 입력하세요.",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => pressCancelButton(provider),
                      icon: const Icon(
                        Icons.clear,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              (() {
                if (provider.searchMode == SearchMode.focused) {
                  ScrollController scrollController = ScrollController();
                  return getSearchArea(
                    provider.searchHistory.isNotEmpty
                        ? CustomScrollbarWidget(
                            scrollController: scrollController,
                            childWidget: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: provider.searchHistory.asMap().entries.map(
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
                                ).toList(),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("검색 기록이 비어있습니다."),
                          ),
                  );
                } // 자동 완성 표시
                else if (provider.searchMode == SearchMode.searching) {
                  _getProductAutoCompleteFuture = productService.getProductAutocomplete(provider.keyword);
                  return getSearchArea(
                    FutureBuilder(
                      future: _getProductAutoCompleteFuture,
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError) {
                          DioFailError error = snapshot.error as DioFailError;
                          if (error.message.contains("Timeout") || error.message.contains('Socket')) {
                            return NetworkErrorHandlerWidget(reconnectCallback: () {
                              setState(() {
                                _getProductAutoCompleteFuture = productService.getProductAutocomplete(provider.keyword);
                              });
                            });
                          } else {
                            return const InternalServerErrorHandlerWidget();
                          }
                        } else {
                          final autoCompletes = snapshot.data!;
                          ScrollController scrollController = ScrollController();

                          return SizedBox(
                            width: double.infinity,
                            child: autoCompletes.isNotEmpty
                                ? CustomScrollbarWidget(
                                    scrollController: scrollController,
                                    childWidget: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        children: autoCompletes
                                            .map(
                                              (autoComplete) => GestureDetector(
                                                onTap: () => search(autoComplete, provider, updateProductList),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: const BoxDecoration(
                                                    color: Color.fromARGB(255, 245, 245, 245),
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.grey, // 밑줄 색
                                                        width: 0.2, // 밑줄 두께
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(autoComplete),
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
                        }
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: ColoredBox(
                      color: Colors.white,
                      child: FutureBuilder(
                        future: _getAllProductFuture,
                        builder: (BuildContext context, AsyncSnapshot<List<AllProduct>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingHandlerWidget(title: "${provider.keyword}로 검색한 결과 불러오기..");
                          } else if (snapshot.hasError) {
                            DioFailError error = snapshot.error as DioFailError;
                            if (error.message.contains("Timeout") || error.message.contains('Socket')) {
                              return NetworkErrorHandlerWidget(reconnectCallback: () {
                                SearchAllProduct searchAllProduct = SearchAllProduct(
                                  align: filterMap["select-algin"] ?? "DESC",
                                  column: filterMap["select-column"] ?? "createdAt",
                                  category: filterMap["select-category"] ?? "전체",
                                  name: provider.keyword,
                                );

                                setState(() {
                                  _getAllProductFuture = productService.getAllProduct(searchAllProduct);
                                });
                              });
                            } else {
                              return const InternalServerErrorHandlerWidget();
                            }
                          } else if (snapshot.hasData) {
                            final products = snapshot.data!;

                            if (products.isEmpty) {
                              return getNoneProduct(provider.keyword);
                            }

                            return ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  currentAllProduct: products[index],
                                  margin: index != products.length - 1 ? const EdgeInsets.fromLTRB(13, 13, 13, 0) : const EdgeInsets.fromLTRB(13, 13, 13, 10),
                                );
                              },
                            );
                          } else {
                            return getNoneProduct(provider.keyword);
                          }
                        },
                      ),
                    ),
                  );
                }
              })(),
            ],
          ),
        );
      },
    );
  }
}
