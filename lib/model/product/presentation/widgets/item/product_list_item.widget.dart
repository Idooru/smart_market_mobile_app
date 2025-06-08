import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/product/common/mixin/product_item.mixin.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';

class ProductListItemWidget extends StatelessWidget with ProductItem {
  final ResponseSearchProduct product;
  final EdgeInsets margin;

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateDetailProductPage(context, product),
      child: Container(
        width: double.infinity,
        height: 150,
        margin: margin,
        decoration: commonContainerDecoration,
        child: Row(
          children: [
            getProductImageContainer(product),
            getProductDescriptionContainer(product, const EdgeInsets.fromLTRB(0, 10, 0, 0)),
          ],
        ),
      ),
    );
  }
}
