import 'package:flutter/material.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_grid_item.widget.dart';

class ConditionalProductListWidget extends StatelessWidget {
  final String title;
  final List<ResponseSearchProduct> products;

  const ConditionalProductListWidget({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: products.map((product) => ProductGridItemWidget(product: product)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
