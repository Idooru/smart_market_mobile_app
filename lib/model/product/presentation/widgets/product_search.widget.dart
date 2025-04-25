import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/product/domain/entities/request/search_all_product.entity.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/filter.widget.dart';

class ProductSearchWidget extends StatefulWidget {
  final void Function(SearchAllProduct) searchCallback;

  const ProductSearchWidget({
    super.key,
    required this.searchCallback,
  });

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      final provider = context.read<ProductSearchProvider>();
      if (!mounted) return;
      if (focusNode.hasFocus && provider.search.isNotEmpty) {
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
        return Expanded(
          child: Container(
            color: Colors.blueGrey[100],
            height: 45,
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: provider.controller,
              textInputAction: TextInputAction.search,
              focusNode: focusNode,
              onChanged: (String search) {
                if (search.isEmpty) {
                  provider.setSearchMode(SearchMode.focused);
                } else {
                  provider.setSearchMode(SearchMode.searching);
                }
              },
              onSubmitted: (String text) => search(text, provider),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    focusNode.requestFocus();
                  },
                ),
                hintText: "상품 이름 검색",
              ),
            ),
          ),
        );
      },
    );
  }
}
