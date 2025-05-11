import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/presentation/pages/detail_product.page.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/item/highlight_filtered_product.widget.dart';

mixin ProductItem {
  void navigateDetailProductPage(BuildContext context, ResponseSearchProduct product) {
    Navigator.of(context).pushNamed(
      "/detail_product",
      arguments: DetailProductPageArgs(productId: product.id),
    );
  }

  Text getNameWidget(ResponseSearchProduct product) {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 61, 61, 61), fontWeight: FontWeight.w300),
      overflow: TextOverflow.ellipsis, // overflow 처리
      maxLines: 1, // 최대 한 줄로 제한
    );
  }

  Text getPriceWidget(ResponseSearchProduct product) {
    return Text(
      "${product.price}원",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text getAverageScoreText() {
    return const Text("평점: ", style: TextStyle(fontSize: 13));
  }

  Text getCategoryText(ResponseSearchProduct product) {
    return Text(
      "카테고리: ${product.category}",
      style: const TextStyle(fontSize: 13),
    );
  }

  Text getCreatedAtText(ResponseSearchProduct product) {
    return Text(
      "게시일: ${parseDate(product.createdAt)}",
      style: const TextStyle(fontSize: 13),
    );
  }

  Text getReviewText(ResponseSearchProduct product) {
    return Text.rich(
      TextSpan(
        text: "리뷰: ",
        style: const TextStyle(fontSize: 13),
        children: [getReviewCount(product)],
      ),
    );
  }

  TextSpan getReviewCount(ResponseSearchProduct product) {
    return TextSpan(
      text: "${product.reviewCount}",
      style: const TextStyle(fontSize: 13, color: Colors.red),
    );
  }

  Widget getProductImageContainer(ResponseSearchProduct product) {
    return Container(
      width: 130,
      height: 130,
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          product.imageUrls[0],
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget getProductDescriptionContainer(ResponseSearchProduct product, EdgeInsets margin) {
    return Container(
      margin: margin,
      child: Consumer<ProductFilteredProvider>(
        builder: (BuildContext context, ProductFilteredProvider provider, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              provider.isNameFiltered ? HighlightFilteredProductWidget(textWidget: getNameWidget(product)) : getNameWidget(product),
              provider.isPriceFiltered ? HighlightFilteredProductWidget(textWidget: getPriceWidget(product)) : getPriceWidget(product),
              Row(
                children: [
                  provider.isAverageScoreFiltered ? HighlightFilteredProductWidget(textWidget: getAverageScoreText()) : getAverageScoreText(),
                  DisplayAverageScoreWidget(averageScore: product.averageScore),
                ],
              ),
              provider.isCategoryFiltered ? HighlightFilteredProductWidget(textWidget: getCategoryText(product)) : getCategoryText(product),
              provider.isCreatedAtFiltered ? HighlightFilteredProductWidget(textWidget: getCreatedAtText(product)) : getCreatedAtText(product),
              provider.isReviewFiltered ? HighlightFilteredProductWidget(textWidget: getReviewText(product)) : getReviewText(product),
            ],
          );
        },
      ),
    );
  }
}
