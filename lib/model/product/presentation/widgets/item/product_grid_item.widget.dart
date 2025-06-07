import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/product/common/mixin/product_item.mixin.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';

class ProductGridItemWidget extends StatelessWidget with ProductItem {
  final ResponseSearchProduct product;

  const ProductGridItemWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateDetailProductPage(context, product),
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(5),
        decoration: commonContainerDecoration,
        child: Column(
          children: [
            getProductImageContainer(product),
            getProductDescriptionContainer(
              product,
              const EdgeInsets.only(left: 10, bottom: 10),
            ),
          ],
        ),
      ),
    );
  }
}
