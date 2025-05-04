import 'package:flutter/material.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

class ProductTextFieldSearchBarWidget extends StatelessWidget {
  final ProductSearchProvider provider;
  final FocusNode focusNode;
  final void Function(ProductSearchProvider provider) pressCancelButton;
  final void Function(String keyword, ProductSearchProvider provider, void Function(RequestSearchProducts) callback) search;
  final void Function(RequestSearchProducts args) updateProductList;

  const ProductTextFieldSearchBarWidget({
    super.key,
    required this.provider,
    required this.focusNode,
    required this.pressCancelButton,
    required this.search,
    required this.updateProductList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
