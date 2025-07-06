import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/review/common/const/request_all_review.args.dart';
import 'package:smart_market/model/review/domain/entity/all_review.entity.dart';
import 'package:smart_market/model/review/domain/service/review.service.dart';

import '../../../../../core/utils/get_it_initializer.dart';
import '../../../../product/presentation/pages/detail_product.page.dart';
import '../../../../product/presentation/widgets/display_average_score.widget.dart';
import '../../pages/detail_review/detail_review.page.dart';

class AllReviewItemWidget extends StatelessWidget {
  final ResponseAllReview responseAllReview;
  final EdgeInsets margin;
  final void Function(RequestAllReviews) updateCallback;

  const AllReviewItemWidget({
    super.key,
    required this.responseAllReview,
    required this.margin,
    required this.updateCallback,
  });

  void pressTrailingIcon(BuildContext context) {
    final ReviewService reviewService = locator<ReviewService>();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    "/detail_product",
                    arguments: DetailProductPageArgs(productId: responseAllReview.product.id),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.open_in_new),
                  title: Text("상품 상세 보기"),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  NavigatorState navigator = Navigator.of(context);
                  navigator.pop();

                  Object? result = await navigator.pushNamed(
                    "/detail_review",
                    arguments: DetailReviewPageArgs(
                      reviewId: responseAllReview.review.id,
                      productId: responseAllReview.product.id,
                      productName: responseAllReview.product.name,
                      backRoute: "/all_reviews",
                    ),
                  );

                  if (result == true) {
                    updateCallback(RequestAllReviewsArgs.args);
                    navigator.popUntil(ModalRoute.withName("/all_reviews"));
                  }
                },
                child: const ListTile(
                  leading: Icon(Icons.reviews),
                  title: Text("리뷰 상세 보기"),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await reviewService.deleteReview(responseAllReview.review.id);
                  updateCallback(RequestAllReviewsArgs.args);
                },
                child: const ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("리뷰 삭제"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => pressTrailingIcon(context),
      child: Container(
        width: double.infinity,
        height: 90,
        margin: margin,
        decoration: commonContainerDecoration,
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  responseAllReview.product.imageUrls[0],
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 90,
              child: Text(
                responseAllReview.product.name,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 50, 50, 50),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Positioned(
              top: 27,
              left: 90,
              child: Text(
                "상품에 리뷰를 작성하였습니다.",
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 100, 100, 100),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Positioned(
              top: 48,
              left: 90,
              child: Row(
                children: [
                  const Text(
                    "별점: ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 90, 90, 90),
                    ),
                  ),
                  DisplayAverageScoreWidget(
                    averageScore: responseAllReview.review.starRateScore.toDouble(),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 64,
              left: 90,
              child: Text(
                "작성일: ${responseAllReview.review.createdAt}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 100, 100, 100),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: -5,
              child: IconButton(
                onPressed: () => pressTrailingIcon(context),
                icon: const Icon(Icons.more_vert, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
