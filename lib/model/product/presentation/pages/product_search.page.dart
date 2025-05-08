import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_filter.dialog.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_button_search_bar.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_search_focused.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_search_result.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_textfield_search_bar.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_searching.widget.dart';

class ProductSearchPageArgs {
  final String keyword;

  const ProductSearchPageArgs({required this.keyword});
}

class ProductSearchPage extends StatefulWidget {
  final String? keyword;

  const ProductSearchPage({
    super.key,
    this.keyword,
  });

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ProductService productService = locator<ProductService>();
  final FocusNode focusNode = FocusNode();

  late ProductSearchProvider provider;
  Future<List<ResponseSearchProduct>>? getAllProductFuture;

  @override
  void initState() {
    super.initState();
    provider = context.read<ProductSearchProvider>();

    if (widget.keyword != null) {
      RequestSearchProducts args = RequestSearchProducts(
        mode: RequestProductSearchMode.category,
        keyword: widget.keyword!,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.setKeyword(widget.keyword!);
        provider.setSearchMode(SearchMode.none);
        updateProductList(args);
      });
    } else {
      focusNode.requestFocus();
      focusNode.addListener(() {
        if (focusNode.hasFocus && provider.keyword.isNotEmpty) {
          provider.setSearchMode(SearchMode.searching);
        } else if (focusNode.hasFocus) {
          provider.setSearchMode(SearchMode.focused);
        } else {
          provider.setSearchMode(SearchMode.none);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setKeyword("");
      provider.setSearchMode(SearchMode.focused);
    });
  }

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

  void updateProductList(RequestSearchProducts args) {
    setState(() {
      getAllProductFuture = productService.getSearchProduct(args);
    });
  }

  void pressCancelButton(ProductSearchProvider provider) {
    provider.setKeyword("");
    provider.setSearchMode(SearchMode.focused);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void search(String keyword, ProductSearchProvider provider, void Function(RequestSearchProducts) callback) {
    RequestSearchProducts searchProduct = RequestSearchProducts(mode: RequestProductSearchMode.manual, keyword: keyword);

    if (provider.isSetHistory) {
      provider.appendHistory(keyword);
    }

    provider.setKeyword(keyword);
    provider.setSearchMode(SearchMode.none);
    callback(searchProduct);
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSearchProvider>(
      builder: (BuildContext context, ProductSearchProvider provider, Widget? child) {
        return Scaffold(
          // 검색중이 아닐 때는 AppBar 위젯 가리기, 검색중일 때는 AppBar 위젯 표시하기
          appBar: provider.searchMode != SearchMode.none
              ? AppBar(
                  title: const Text("Search"),
                  centerTitle: false,
                  flexibleSpace: Container(
                    color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
                  ),
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
                      final state = context.findAncestorStateOfType<NavigationPageState>();
                      state?.tapBottomNavigator(0); // AllProductPage
                    },
                  ),
                )
              : null,
          body: ColoredBox(
            color: Colors.white,
            // 검색중이 아닐 때는 Sliver 위젯 사용, 검색중일 때는 일반 Scafold 위젯 사용
            child: provider.searchMode == SearchMode.none
                ? CustomScrollView(
                    slivers: [
                      // header
                      SliverAppBar(
                        flexibleSpace: Container(
                          color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
                        ),
                        pinned: false,
                        floating: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            final state = context.findAncestorStateOfType<NavigationPageState>();
                            state?.tapBottomNavigator(0);
                          },
                        ),
                        title: const Text("Search"),
                        centerTitle: false,
                        actions: provider.searchMode == SearchMode.none && provider.keyword.isNotEmpty
                            ? [
                                IconButton(
                                  onPressed: () => ProductFilterDialog.show(context, updateProductList),
                                  icon: const Icon(Icons.tune, color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.view_agenda_outlined, color: Colors.black),
                                ),
                              ]
                            : [],
                      ),
                      ProductButtonSearchBarWidget(
                        provider: provider,
                        searchBarCall: SearchBarCall.search,
                        pressCallback: () {
                          provider.setSearchMode(SearchMode.searching);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            focusNode.requestFocus();
                          });
                        },
                        pressCancelButton: pressCancelButton,
                      ),
                      ProductSearchResultWidget(
                        provider: provider,
                        getAllProductFuture: getAllProductFuture!,
                        reconnectCallback: () {
                          RequestSearchProduct searchAllProduct = RequestSearchProduct(
                            align: filterMap["select-algin"] ?? "DESC",
                            column: filterMap["select-column"] ?? "createdAt",
                            category: filterMap["select-category"] ?? "전체",
                            name: provider.keyword,
                          );

                          setState(() {
                            getAllProductFuture = productService.getAllProduct(searchAllProduct);
                          });
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ProductTextFieldSearchBarWidget(
                        provider: provider,
                        focusNode: focusNode,
                        pressCancelButton: pressCancelButton,
                        search: search,
                        updateProductList: updateProductList,
                      ),
                      (() {
                        if (provider.searchMode == SearchMode.focused) {
                          return ProductSearchFocusedWidget(
                            provider: provider,
                            search: search,
                            updateProductList: updateProductList,
                          );
                        } // 자동 완성 표시
                        else if (provider.searchMode == SearchMode.searching) {
                          return ProductSearchingWidget(
                            provider: provider,
                            search: search,
                            updateProductList: updateProductList,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      })()
                    ],
                  ),
          ),
        );
      },
    );
  }
}
