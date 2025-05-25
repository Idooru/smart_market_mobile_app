import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/main/presentation/widgets/category_list.widget.dart';
import 'package:smart_market/model/main/presentation/widgets/conditional_product_list.widget.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/search/product_button_search_bar.widget.dart';

class MainPage extends StatelessWidget {
  final Map<String, dynamic> pageArgs;

  const MainPage({
    super.key,
    required this.pageArgs,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSearchProvider>(
      builder: (BuildContext context, ProductSearchProvider provider, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text("Smart Market"),
                pinned: false,
                floating: true,
                snap: true,
                flexibleSpace: Container(
                  color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
                ),
              ),
              ProductButtonSearchBarWidget(
                provider: provider,
                searchBarCall: SearchBarCall.main,
                pressCallback: () {
                  final state = context.findAncestorStateOfType<NavigationPageState>();
                  state?.tapBottomNavigator(1); // index 1 = ProductSearchPage
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
                        products: pageArgs["high-rated-products"],
                      ),
                      ConditionalProductListWidget(
                        title: "가장 리뷰 많은 상품",
                        products: pageArgs["most-review-products"],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
