import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';

class ProductItemWidget extends StatelessWidget {
  final ResponseSearchProduct currentAllProduct;
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

  Text getNameWidget() {
    return Text(
      currentAllProduct.name,
      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 61, 61, 61), fontWeight: FontWeight.w300),
    );
  }

  Text getPriceWidget() {
    return Text(
      "${currentAllProduct.price}원",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text getAverageScoreText() {
    return const Text("평점: ", style: TextStyle(fontSize: 13));
  }

  Text getCategoryText() {
    return Text(
      "카테고리: ${currentAllProduct.category}",
      style: const TextStyle(fontSize: 13),
    );
  }

  Text getCreatedAtText() {
    return Text(
      "게시일: ${parseDate(currentAllProduct.createdAt)}",
      style: const TextStyle(fontSize: 13),
    );
  }

  Text getReviewText() {
    return Text.rich(
      TextSpan(
        text: "리뷰: ",
        style: const TextStyle(fontSize: 13),
        children: [getReviewCount()],
      ),
    );
  }

  TextSpan getReviewCount() {
    return TextSpan(
      text: "${currentAllProduct.reviewCount}",
      style: const TextStyle(fontSize: 13, color: Colors.red),
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
                child: Consumer<ProductFilteredProvider>(
                  builder: (BuildContext context, ProductFilteredProvider provider, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        provider.isNameFiltered ? _HighlightFilteredProductWidget(textWidget: getNameWidget()) : getNameWidget(),
                        provider.isPriceFiltered ? _HighlightFilteredProductWidget(textWidget: getPriceWidget()) : getPriceWidget(),
                        Row(
                          children: [
                            provider.isAverageScoreFiltered ? _HighlightFilteredProductWidget(textWidget: getAverageScoreText()) : getAverageScoreText(),
                            DisplayAverageScoreWidget(averageScore: currentAllProduct.averageScore),
                          ],
                        ),
                        provider.isCategoryFiltered ? _HighlightFilteredProductWidget(textWidget: getCategoryText()) : getCategoryText(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            provider.isCreatedAtFiltered ? _HighlightFilteredProductWidget(textWidget: getCreatedAtText()) : getCreatedAtText(),
                            provider.isReviewFiltered ? _HighlightFilteredProductWidget(textWidget: getReviewText()) : getReviewText(),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HighlightFilteredProductWidget extends StatefulWidget {
  final Text textWidget;

  const _HighlightFilteredProductWidget({required this.textWidget});

  @override
  State<_HighlightFilteredProductWidget> createState() => _HighlightFilteredProductWidgetState();
}

class _HighlightFilteredProductWidgetState extends State<_HighlightFilteredProductWidget> {
  bool _showShimmer = true;
  Timer? _shimmerTimer;

  late ProductFilteredProvider productFilteredProvider;

  @override
  void initState() {
    super.initState();
    _shimmerTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showShimmer = false;
        });
        productFilteredProvider.clearFiltered();
      }
    });
  }

  @override
  void dispose() {
    _shimmerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productFilteredProvider = context.watch<ProductFilteredProvider>();

    return _showShimmer
        ? Shimmer.fromColors(
            baseColor: Colors.yellow[700]!,
            highlightColor: Colors.red[700]!,
            child: widget.textWidget,
          )
        : widget.textWidget;
  }
}
