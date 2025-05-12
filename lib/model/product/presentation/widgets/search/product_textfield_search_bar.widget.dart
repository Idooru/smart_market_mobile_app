import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

class ProductTextFieldSearchBarWidget extends StatelessWidget {
  final FocusNode focusNode;
  final void Function(ProductSearchProvider provider) pressCancelButton;
  final void Function(String keyword, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, void Function(RequestSearchProducts) callback) search;
  final void Function(RequestSearchProducts args) updateProductList;

  const ProductTextFieldSearchBarWidget({
    super.key,
    required this.focusNode,
    required this.pressCancelButton,
    required this.search,
    required this.updateProductList,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductSearchProvider, ProductFilteredProvider>(
      builder: (BuildContext context, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, Widget? child) {
        return Container(
          color: Colors.blueGrey[100],
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchProvider.controller,
                  textInputAction: TextInputAction.search,
                  focusNode: focusNode,
                  onChanged: (String keyword) {
                    if (keyword.isEmpty) {
                      searchProvider.setSearchMode(SearchMode.focused);
                    } else {
                      searchProvider.setSearchMode(SearchMode.searching);
                    }
                  },
                  onSubmitted: (String keyword) => search(keyword, searchProvider, filteredProvider, updateProductList),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: "상품 이름을 입력하세요.",
                  ),
                ),
              ),
              IconButton(
                onPressed: () => pressCancelButton(searchProvider),
                icon: const Icon(Icons.clear, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
