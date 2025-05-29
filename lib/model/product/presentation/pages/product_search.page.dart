import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/product/common/const/%08product_category.const.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_filter.dialog.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_button_search_bar.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_search_focused.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_search_result.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_searching.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_textfield_search_bar.widget.dart';

import '../../../../core/errors/connection_error.dart';

enum ViewMode {
  list,
  grid,
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
  String? _keyword;

  late ViewMode viewMode;
  late ProductSearchProvider searchProvider;
  late ProductFilteredProvider filteredProvider;

  @override
  void initState() {
    super.initState();
    searchProvider = context.read<ProductSearchProvider>();
    filteredProvider = context.read<ProductFilteredProvider>();
    viewMode = ViewMode.list;

    if (searchProvider.keyword.isNotEmpty) {
      _keyword = searchProvider.keyword;

      RequestSearchProducts args = RequestSearchProducts(
        mode: RequestProductSearchMode.category,
        keyword: searchProvider.keyword,
      );

      updateProductList(args);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchProvider.setSearchMode(SearchMode.none);
      });
    } else {
      focusNode.requestFocus();
      focusNode.addListener(() {
        if (focusNode.hasFocus && searchProvider.keyword.isNotEmpty) {
          searchProvider.setSearchMode(SearchMode.searching);
        } else if (focusNode.hasFocus) {
          searchProvider.setSearchMode(SearchMode.focused);
        } else {
          searchProvider.setSearchMode(SearchMode.none);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchProvider.clearAll();
      filteredProvider.clearAll();
    });
  }

  void updateProductList(RequestSearchProducts args) async {
    try {
      List<ResponseSearchProduct> products = await productService.getSearchProduct(args);
      searchProvider.setProducts(products);
      searchProvider.setFail(SearchProductFail.none);
    } catch (err) {
      searchProvider.setFail(
        err is ConnectionError ? SearchProductFail.noneConnectionException : SearchProductFail.internalServerException,
      );
    }
  }

  void updateViewMode() {
    setState(() {
      if (viewMode == ViewMode.list) {
        viewMode = ViewMode.grid;
      } else {
        viewMode = ViewMode.list;
      }
    });
  }

  void pressCancelButton(ProductSearchProvider provider) {
    provider.setKeyword("");
    provider.setSearchMode(SearchMode.focused);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void search(String keyword, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, void Function(RequestSearchProducts) callback) {
    if (keyword.isEmpty) return;

    _keyword = keyword;

    RequestSearchProducts searchProduct = RequestSearchProducts(
      mode: productCategory.contains(keyword) ? RequestProductSearchMode.category : RequestProductSearchMode.manual,
      keyword: keyword,
    );

    if (searchProvider.isSetHistory) {
      searchProvider.appendHistory(keyword);
    }

    searchProvider.setKeyword(keyword);
    searchProvider.setSearchMode(SearchMode.none);
    callback(searchProduct);
    focusNode.unfocus();
    filteredProvider.setIsFiltered(false);
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
                        actions: [
                          IconButton(
                            onPressed: () => ProductFilterDialog.show(context),
                            icon: const Icon(
                              Icons.tune,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: updateViewMode,
                            icon: Icon(
                              viewMode == ViewMode.list ? Icons.list : Icons.grid_3x3,
                              color: Colors.black,
                            ),
                          ),
                        ],
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
                        viewMode: viewMode,
                        reconnectCallback: () {
                          RequestSearchProducts searchProduct = RequestSearchProducts(
                            mode: productCategory.contains(_keyword) ? RequestProductSearchMode.category : RequestProductSearchMode.manual,
                            keyword: _keyword!,
                          );

                          updateProductList(searchProduct);
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ProductTextFieldSearchBarWidget(
                        focusNode: focusNode,
                        pressCancelButton: pressCancelButton,
                        search: search,
                        updateProductList: updateProductList,
                      ),
                      (() {
                        if (provider.searchMode == SearchMode.focused) {
                          return ProductSearchFocusedWidget(
                            search: search,
                            updateProductList: updateProductList,
                          );
                        } // 자동 완성 표시
                        else if (provider.searchMode == SearchMode.searching) {
                          return ProductSearchingWidget(
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
