import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_grid_item.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_list_item.widget.dart';

import '../../../../../core/errors/connection_error.dart';
import '../../../../../core/utils/get_it_initializer.dart';
import '../../../common/const/product_category.const.dart';
import '../../../common/const/product_pagincation.const.dart';
import '../../../domain/service/product.service.dart';

class ProductSearchResultWidget extends StatefulWidget {
  final void Function() reconnectCallback;
  final ViewMode viewMode;
  final String? keyword;
  final ScrollController scrollController;

  const ProductSearchResultWidget({
    super.key,
    required this.viewMode,
    required this.reconnectCallback,
    required this.keyword,
    required this.scrollController,
  });

  @override
  State<ProductSearchResultWidget> createState() => _ProductSearchResultWidgetState();
}

class _ProductSearchResultWidgetState extends State<ProductSearchResultWidget> {
  final ProductService productService = locator<ProductService>();
  bool _isLoadingMore = false;
  bool _isInitialLoading = true; // 추가
  bool _hasMore = true;

  late ProductSearchProvider searchProvider;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    searchProvider = context.read<ProductSearchProvider>();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isInitialLoading = false);
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore) return;
    if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent - 50) {
      _triggerLoadMore();
    }
  }

  Future<void> _triggerLoadMore() async {
    if (_isLoadingMore) return; // 중복 실행 방지

    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
    // TODO: 여기서 추가 데이터 로드 로직 실행

    RequestSearchProducts searchProduct = RequestSearchProducts(
      mode: productCategory.contains(widget.keyword) ? RequestProductSearchMode.category : RequestProductSearchMode.manual,
      keyword: widget.keyword!,
      sequence: searchProvider.products.last.sequence + 1,
      count: count,
    );

    await updateProductList(searchProduct);
  }

  Widget getProductCountContainer(List<ResponseSearchProduct> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 40,
        decoration: commonContainerDecoration,
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

  Widget getLoadingIndicator() {
    // 로딩 인디케이터
    return _isLoadingMore
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(color: Colors.black),
          )
        : SizedBox.shrink();
  }

  Future<void> updateProductList(RequestSearchProducts args) async {
    try {
      List<ResponseSearchProduct> products = await productService.getSearchProduct(args);

      if (products.isEmpty) {
        _hasMore = false; // 더 이상 데이터 없음
      } else {
        searchProvider.addProducts(products);
      }

      searchProvider.setFail(SearchProductFail.none);
    } catch (err) {
      searchProvider.setFail(
        err is ConnectionError ? SearchProductFail.noneConnectionException : SearchProductFail.internalServerException,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductSearchProvider, ProductFilteredProvider>(
      builder: (BuildContext context, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, Widget? child) {
        return Consumer2<ProductSearchProvider, ProductFilteredProvider>(
          builder: (BuildContext context, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, Widget? child) {
            return SliverToBoxAdapter(
              child: _isInitialLoading // ← FutureBuilder 대신
                  ? Column(
                      children: [
                        const SizedBox(height: 100),
                        LoadingHandlerWidget(title: "${searchProvider.keyword}${filteredProvider.isFiltered ? "에서 정렬" : "(으)로 검색"} 한 결과 불러오기.."),
                      ],
                    )
                  : Builder(
                      // ← 기존 분기 로직
                      builder: (context) {
                        List<ResponseSearchProduct> products = filteredProvider.isFiltered ? filteredProvider.products : searchProvider.products;

                        if (searchProvider.fail == SearchProductFail.noneConnectionException) {
                          return Column(
                            children: [
                              const SizedBox(height: 100),
                              NetworkErrorHandlerWidget(reconnectCallback: widget.reconnectCallback),
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
                          // 기존 list/grid 분기
                          if (widget.viewMode == ViewMode.list) {
                            return Column(
                              children: [
                                ListView(
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
                                ),
                                getLoadingIndicator()
                              ],
                            );
                          } else {
                            return Column(children: [
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
                              getLoadingIndicator()
                            ]);
                          }
                        }
                      },
                    ),
            );
          },
        );
        // return SliverToBoxAdapter(
        //   child: FutureBuilder(
        //     future: Future.delayed(Duration(milliseconds: searchProvider.fail == SearchProductFail.noneConnectionException ? 3000 : 300)),
        //     builder: (context, snapshot) {
        //       List<ResponseSearchProduct> products = filteredProvider.isFiltered ? filteredProvider.products : searchProvider.products;
        //       if (snapshot.connectionState != ConnectionState.done) {
        //         return Column(
        //           children: [
        //             const SizedBox(height: 100),
        //             LoadingHandlerWidget(title: "${searchProvider.keyword}${filteredProvider.isFiltered ? "에서 정렬" : "(으)로 검색"} 한 결과 불러오기.."),
        //           ],
        //         );
        //       } else {
        //         if (searchProvider.fail == SearchProductFail.noneConnectionException) {
        //           return Column(
        //             children: [
        //               const SizedBox(height: 100),
        //               NetworkErrorHandlerWidget(reconnectCallback: widget.reconnectCallback),
        //             ],
        //           );
        //         } else if (searchProvider.fail == SearchProductFail.internalServerException) {
        //           return const Column(
        //             children: [
        //               SizedBox(height: 100),
        //               InternalServerErrorHandlerWidget(),
        //             ],
        //           );
        //         } else if (products.isEmpty) {
        //           return const Column(
        //             children: [
        //               SizedBox(height: 100),
        //               Text("검색 결과가 없습니다."),
        //             ],
        //           );
        //         } else {
        //           if (widget.viewMode == ViewMode.list) {
        //             return Column(
        //               children: [
        //                 ListView(
        //                   shrinkWrap: true,
        //                   physics: const NeverScrollableScrollPhysics(),
        //                   children: [
        //                     // 상품 갯수 정보 표시
        //                     getProductCountContainer(products),
        //                     // 실제 상품 목록
        //                     ...products.asMap().entries.map(
        //                       (entry) {
        //                         final index = entry.key;
        //                         final product = entry.value;
        //                         final isLast = index == products.length - 1;
        //                         return ProductListItemWidget(
        //                           product: product,
        //                           margin: isLast ? const EdgeInsets.fromLTRB(13, 13, 13, 10) : const EdgeInsets.fromLTRB(13, 13, 13, 0),
        //                         );
        //                       },
        //                     ),
        //                   ],
        //                 ),
        //                 // 로딩 인디케이터
        //                 if (_isLoadingMore)
        //                   const Padding(
        //                     padding: EdgeInsets.symmetric(vertical: 16),
        //                     child: CircularProgressIndicator(),
        //                   ),
        //               ],
        //             );
        //           } else {
        //             return Column(
        //               children: [
        //                 getProductCountContainer(products),
        //                 Padding(
        //                   padding: const EdgeInsets.all(5),
        //                   child: LayoutBuilder(builder: (context, constraints) {
        //                     // 가로 한 줄에 2개의 아이템이 들어가므로
        //                     final width = (constraints.maxWidth - 1.0) / 2;
        //                     // 여기서 높이는 원하는 위젯의 예상 높이로 계산 (예: 이미지 비율 + 텍스트 등 합산)
        //                     final height = width * 1.9; // 비율 조정 예시
        //                     final aspectRatio = width / height;
        //                     return GridView(
        //                       shrinkWrap: true,
        //                       physics: const NeverScrollableScrollPhysics(),
        //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                         crossAxisCount: 2,
        //                         crossAxisSpacing: 1.0,
        //                         mainAxisSpacing: 1.0,
        //                         childAspectRatio: aspectRatio,
        //                       ),
        //                       children: products.map((product) => ProductGridItemWidget(product: product)).toList(),
        //                     );
        //                   }),
        //                 ),
        //                 if (_isLoadingMore)
        //                   const Padding(
        //                     padding: EdgeInsets.symmetric(vertical: 16),
        //                     child: CircularProgressIndicator(),
        //                   ),
        //               ],
        //             );
        //           }
        //         }
        //       }
        //     },
        //   ),
        // );
      },
    );
  }
}
