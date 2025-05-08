import 'package:flutter/material.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';

class CategoryItemWidget extends StatelessWidget {
  final String title;
  final EdgeInsets margin;

  const CategoryItemWidget({
    super.key,
    required this.title,
    required this.margin,
  });

  void pressItem(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/product_search",
      arguments: ProductSearchPageArgs(keyword: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pressItem(context),
      child: Container(
        width: 70,
        height: 70,
        margin: margin,
        decoration: BoxDecoration(
          color: const Color.fromARGB(180, 240, 240, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
