import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';

class ProductItemWidget extends StatelessWidget {
  final AllProduct currentAllProduct;
  final EdgeInsets margin;

  const ProductItemWidget({
    super.key,
    required this.currentAllProduct,
    required this.margin,
  });

  void navigateDetailProductPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/detail_product",
      arguments: DetailProductPageArgs(productId: currentAllProduct.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateDetailProductPage(context),
      child: Container(
        width: double.infinity,
        height: 150,
        margin: margin,
        decoration: BoxDecoration(
          color: const Color.fromARGB(180, 240, 240, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              height: 130,
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  currentAllProduct.imageUrls[0],
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 13, 13, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentAllProduct.name,
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 61, 61, 61), fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "${currentAllProduct.price}원",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    DisplayAverageScoreWidget(averageScore: currentAllProduct.averageScore),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "category: ${currentAllProduct.category}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "review: ",
                            style: const TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                text: "${currentAllProduct.reviewCount}",
                                style: const TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "created date: ${parseDate(currentAllProduct.createdAt)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
