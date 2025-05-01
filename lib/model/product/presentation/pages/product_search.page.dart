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
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_filter.dialog.dart';
import 'package:smart_market/model/product/presentation/widgets/product_item.widget.dart';

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  double get minExtent => 45;

  @override
  double get maxExtent => 45;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ProductService productService = locator<ProductService>();
  final FocusNode focusNode = FocusNode();

  Future<List<ResponseSearchProduct>>? _getAllProductFuture;
  late Future<List<String>> _getProductAutoCompleteFuture;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductSearchProvider>();

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
      _getAllProductFuture = productService.getSearchProduct(args);
    });
  }

  void pressCancelButton(ProductSearchProvider provider) {
    focusNode.requestFocus();
    provider.setKeyword("");
    provider.setSearchMode(SearchMode.focused);
  }

  void search(String keyword, ProductSearchProvider provider, void Function(RequestSearchProducts) callback) {
    RequestSearchProducts searchProduct = RequestSearchProducts(mode: RequestProductSearchMode.manual, keyword: keyword);

    if (provider.isSetHistory) {
      provider.appendHistory(keyword);
    }

    provider.setKeyword(keyword);
    provider.setSearchMode(SearchMode.none);
    callback(searchProduct);
  }

  String getInitial(String text) {
    const int base = 0xAC00;
    const List<String> initials = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

    return text.split('').map((char) {
      int code = char.codeUnitAt(0) - base;
      if (code < 0 || code > 11171) return char;

      int initialIndex = code ~/ (21 * 28);
      return initials[initialIndex];
    }).join();
  }

  List<TextSpan> highlightInitialMatch(String text, String keyword) {
    final initials = getInitial(text);
    final index = initials.indexOf(keyword);

    if (index == -1 || keyword.isEmpty) {
      return [TextSpan(text: text)];
    }

    return [
      TextSpan(text: text.substring(0, index)),
      TextSpan(
        text: text.substring(index, index + keyword.length),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: text.substring(index + keyword.length)),
    ];
  }

  List<TextSpan> highlightKeyword(String text, String keyword) {
    final List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final index = text.indexOf(keyword, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + keyword.length),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

      start = index + keyword.length;
    }

    return spans;
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
                      final state = context.findAncestorStateOfType<AppMainPageState>();
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
                            final state = context.findAncestorStateOfType<AppMainPageState>();
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
                      // 검색창
                      SliverPersistentHeader(
                        pinned: true, // 스크롤해도 고정
                        floating: false,
                        delegate: _SearchBarDelegate(
                          child: Container(
                            color: Colors.blueGrey[100],
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                    },
                                    onSubmitted: (keyword) => search(keyword, provider, updateProductList),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search, color: Colors.black),
                                      hintText: "상품 이름을 입력하세요.",
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => pressCancelButton(provider),
                                  icon: const Icon(Icons.clear, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 검색 결과
                      SliverToBoxAdapter(
                        child: FutureBuilder(
                          future: _getAllProductFuture,
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
                                    NetworkErrorHandlerWidget(reconnectCallback: () {
                                      RequestSearchProduct searchAllProduct = RequestSearchProduct(
                                        align: filterMap["select-algin"] ?? "DESC",
                                        column: filterMap["select-column"] ?? "createdAt",
                                        category: filterMap["select-category"] ?? "전체",
                                        name: provider.keyword,
                                      );

                                      setState(() {
                                        _getAllProductFuture = productService.getAllProduct(searchAllProduct);
                                      });
                                    })
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
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        color: Colors.blueGrey[100],
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                },
                                onSubmitted: (String keyword) => search(keyword, provider, updateProductList),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search, color: Colors.black),
                                  hintText: "상품 이름을 입력하세요.",
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => pressCancelButton(provider),
                              icon: const Icon(Icons.clear, size: 20),
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
                                  List<String> autoCompletes = snapshot.data!;
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
                                                          child: Text.rich(
                                                            TextSpan(
                                                                children: RegExp(r'^[ㄱ-ㅎ]+$').hasMatch(provider.keyword)
                                                                    ? highlightInitialMatch(autoComplete, provider.keyword)
                                                                    : highlightKeyword(autoComplete, provider.keyword)),
                                                          ),
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
