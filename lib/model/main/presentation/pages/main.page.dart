import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../product/domain/entities/search_product.entity.dart';
import '../../../product/domain/service/product.service.dart';
import '../../../product/presentation/widgets/search/product_button_search_bar.widget.dart';
import '../widgets/category_list.widget.dart';
import '../widgets/conditional_product_list.widget.dart';
import 'navigation.page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ProductService _service = locator<ProductService>();
  late Future<Map<String, dynamic>> _mainPageFuture;

  @override
  void initState() {
    super.initState();

    _mainPageFuture = initMainPageFuture();
  }

  Future<Map<String, dynamic>> initMainPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));

    RequestConditionalProducts highRatedProductArgs = const RequestConditionalProducts(count: 10, condition: "high-rated-product");
    RequestConditionalProducts mostReviewProductArgs = const RequestConditionalProducts(count: 10, condition: "most-review-product");

    List<ResponseSearchProduct> highRatedProducts = await _service.getConditionalProducts(highRatedProductArgs);
    List<ResponseSearchProduct> mostReviewProducts = await _service.getConditionalProducts(mostReviewProductArgs);

    return {"high-rated-products": highRatedProducts, "most-review-products": mostReviewProducts};
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSearchProvider>(
      builder: (BuildContext context, ProductSearchProvider provider, Widget? child) {
        return Scaffold(
          body: FutureBuilder<Map<String, dynamic>>(
            future: _mainPageFuture,
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingHandlerWidget(title: "메인 페이지 불러오기..");
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                if (error is ConnectionError) {
                  return NetworkErrorHandlerWidget(reconnectCallback: () {
                    setState(() {
                      _mainPageFuture = initMainPageFuture();
                    });
                  });
                } else if (error is DioFailError) {
                  return const InternalServerErrorHandlerWidget();
                } else {
                  return Center(child: Text("$error"));
                }
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: const Text("Smart Market"),
                      pinned: false,
                      floating: true,
                      snap: true,
                      flexibleSpace: Container(
                        color: const Color.fromARGB(255, 240, 240, 240), // 스크롤 될 시 색상 변경 방지
                      ),
                    ),
                    ProductButtonSearchBarWidget(
                      provider: provider,
                      searchBarCall: SearchBarCall.main,
                      pressCallback: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/home",
                          (route) => false,
                          arguments: const NavigationPageArgs(selectedIndex: 1),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const CategoryListWidget(),
                            ConditionalProductListWidget(
                              title: "가장 별점 높은 상품",
                              products: snapshot.data!["high-rated-products"],
                            ),
                            ConditionalProductListWidget(
                              title: "가장 리뷰 많은 상품",
                              products: snapshot.data!["most-review-products"],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
