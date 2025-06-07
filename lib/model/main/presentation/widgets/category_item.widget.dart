import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final String title;
  final EdgeInsets margin;
  final Icon icon;

  const CategoryItemWidget({
    super.key,
    required this.title,
    required this.margin,
    required this.icon,
  });

  void pressItem(BuildContext context) {
    final provider = context.read<ProductSearchProvider>();
    provider.setKeyword(title);
    provider.setSearchMode(SearchMode.none);

    final state = context.findAncestorStateOfType<NavigationPageState>();
    state?.tapBottomNavigator(1);
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
          color: Colors.white,
          border: Border.all(width: 0.6, color: const Color.fromARGB(255, 210, 210, 210)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(title),
          ],
        ),
      ),
    );
  }
}
