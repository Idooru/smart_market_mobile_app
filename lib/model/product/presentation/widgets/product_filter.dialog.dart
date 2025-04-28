import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/widgets/common/radio.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

final Map<String, String> filterMap = {};

class ProductFilterDialog {
  static void show(BuildContext context, void Function(RequestSearchProducts) filterCallback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: ProductFilterDialogWidget(
          filterCallback: filterCallback,
        ),
      ),
    );
  }
}

class ProductFilterDialogWidget extends StatefulWidget {
  final void Function(RequestSearchProducts) filterCallback;

  const ProductFilterDialogWidget({
    super.key,
    required this.filterCallback,
  });

  @override
  State<ProductFilterDialogWidget> createState() => ProductFIlterDialogWidgetState();
}

class ProductFIlterDialogWidgetState extends State<ProductFilterDialogWidget> {
  String _selectedAlign = filterMap["select-align"] ?? "DESC";
  String _selectedColumn = filterMap["select-column"] ?? "createdAt";
  String _selectedCategory = filterMap["select-category"] ?? "전체";

  late ProductFilteredProvider productFilteredProvider;

  void initFilterMap() {
    setState(() {
      _selectedAlign = "DESC";
      _selectedColumn = "createdAt";
      _selectedCategory = "전체";
    });
  }

  void clickToFind(
    ProductFilteredProvider filteredProvider,
    ProductSearchProvider searchProvider,
  ) {
    // filterMap["select-align"] = _selectedAlign;
    // filterMap["select-column"] = _selectedColumn;
    // filterMap["select-category"] = _selectedCategory;

    // RequestSearchProducts searchAllProduct = RequestSearchProducts(
    //   align: _selectedAlign,
    //   column: _selectedColumn,
    //   category: _selectedCategory,
    //   name: searchProvider.keyword,
    // );

    // filteredProvider.clearFiltered();
    // filteredProvider.setFiltering(_selectedColumn, _selectedCategory != "전체");

    // searchProvider.setSearchMode(SearchMode.none);

    // widget.filterCallback(searchAllProduct);

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 285,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "상품 필터링",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "순서",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "낮은순",
                          value: "ASC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "높은순",
                          value: "DESC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "기준",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "생성일",
                          value: "createdAt",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "상품이름",
                          value: "name",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "가격",
                          value: "price",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "리뷰",
                          value: "review",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "별점",
                          value: "score",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "카테고리",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "전체",
                          value: "전체",
                          groupValue: _selectedCategory,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "애완동물",
                          value: "애완동물",
                          groupValue: _selectedCategory,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "가전제품",
                          value: "가전제품",
                          groupValue: _selectedCategory,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "음식",
                          value: "음식",
                          groupValue: _selectedCategory,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: initFilterMap,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 180, 180, 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "필터링 초기화",
                          style: TextStyle(
                            color: Color.fromARGB(255, 70, 70, 70),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Consumer2<ProductFilteredProvider, ProductSearchProvider>(
                  builder: (BuildContext context, ProductFilteredProvider filteredProvider, ProductSearchProvider searchProvider, Widget? child) {
                    return TextButton(
                      onPressed: () => clickToFind(filteredProvider, searchProvider),
                      child: const Text(
                        '찾기',
                        style: TextStyle(
                          color: Color.fromARGB(255, 70, 70, 70),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
