import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';

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

enum SearchBarCall { main, search }

class ProductButtonSearchBarWidget extends StatelessWidget {
  final ProductSearchProvider provider;
  final SearchBarCall searchBarCall;
  final void Function() pressCallback;
  final void Function(ProductSearchProvider provider)? pressCancelButton;

  const ProductButtonSearchBarWidget({
    super.key,
    required this.provider,
    required this.searchBarCall,
    required this.pressCallback,
    this.pressCancelButton,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true, // 스크롤해도 고정
      floating: false,
      delegate: _SearchBarDelegate(
        child: GestureDetector(
          onTap: pressCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: commonContainerDecoration,
              height: 45,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 7, right: 12),
                    child: Icon(Icons.search, color: Color.fromARGB(255, 80, 80, 80)),
                  ),
                  Text(
                    searchBarCall == SearchBarCall.main ? "상품 검색 하기" : provider.keyword,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 80, 80, 80),
                    ),
                  ),
                  const Spacer(),
                  searchBarCall == SearchBarCall.search
                      ? IconButton(
                          onPressed: () => pressCancelButton!(provider),
                          icon: const Icon(Icons.clear, size: 20),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
