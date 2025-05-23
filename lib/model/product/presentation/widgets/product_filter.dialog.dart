import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/widgets/common/radio.widget.dart';
import 'package:smart_market/model/product/common/const/%08product_category.const.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';

final Map<String, String> filterMap = {};

class ProductFilterDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Dialog(
        child: ProductFilterDialogWidget(),
      ),
    );
  }
}

class ProductFilterDialogWidget extends StatefulWidget {
  const ProductFilterDialogWidget({super.key});

  @override
  State<ProductFilterDialogWidget> createState() => ProductFilterDialogWidgetState();
}

class ProductFilterDialogWidgetState extends State<ProductFilterDialogWidget> {
  String _selectedAlign = filterMap["select-align"] ?? "DESC";
  String _selectedColumn = filterMap["select-column"] ?? "createdAt";
  String _selectedCategory = filterMap["select-category"] ?? "전체";

  void initFilterMap() {
    setState(() {
      _selectedAlign = "DESC";
      _selectedColumn = "createdAt";
      _selectedCategory = "전체";
    });
  }

  void filterProduct(
    ProductFilteredProvider filteredProvider,
    ProductSearchProvider searchProvider,
  ) {
    List<ResponseSearchProduct> products = searchProvider.products;
    List<ResponseSearchProduct> sortedProducts = _selectedCategory != "전체" ? products.where((product) => product.category == _selectedCategory).toList() : products;

    sortedProducts.sort((a, b) {
      Map<String, Comparable Function(ResponseSearchProduct)> keyExtractors = {
        "createdAt": (product) => product.createdAt,
        "name": (product) => product.name,
        "price": (product) => product.price,
        "review": (product) => product.reviewCount,
        "score": (product) => product.averageScore,
      };

      final extractor = keyExtractors[_selectedColumn];
      if (extractor == null) return 0;

      final aValue = extractor(a);
      final bValue = extractor(b);

      return _selectedAlign == "ASC" ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });

    filteredProvider.setProducts(sortedProducts);

    filterMap["select-align"] = _selectedAlign;
    filterMap["select-column"] = _selectedColumn;
    filterMap["select-category"] = _selectedCategory;

    filteredProvider.clearChanged();
    filteredProvider.setColumnChanged(_selectedColumn);
    filteredProvider.setCategoryChanged(_selectedCategory != "전체");
    bool isChanged = !(_selectedAlign == "DESC" && _selectedColumn == "createdAt" && _selectedCategory == "전체");
    filteredProvider.setIsFiltered(isChanged);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 285,
      decoration: BoxDecoration(
        color: Colors.white,
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
                      radioWidgets: productCategory
                          .map((category) => RadioItemWidget(
                                optionTitle: category,
                                value: category,
                                groupValue: _selectedCategory,
                                selectRadioCallback: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                              ))
                          .toList(),
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
                      onPressed: () => filterProduct(filteredProvider, searchProvider),
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
