import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/check_jwt_duration.dart';
import 'package:smart_market/model/review/domain/entity/detail_review.entity.dart';
import 'package:smart_market/model/review/domain/service/review.service.dart';
import 'package:smart_market/model/review/presentation/widgets/item/access_review_item.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/errors/refresh_token_expired.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../user/presentation/dialog/force_logout.dialog.dart';
import '../widgets/edit/edit_review_content.widget.dart';
import '../widgets/edit/edit_review_media.widget.dart';
import '../widgets/edit/edit_star_rate.widget.dart';

class DetailReviewPageArgs {
  final String reviewId;
  final String productName;

  const DetailReviewPageArgs({
    required this.reviewId,
    required this.productName,
  });
}

class DetailReviewPage extends StatefulWidget {
  final String reviewId;
  final String productName;

  const DetailReviewPage({
    super.key,
    required this.reviewId,
    required this.productName,
  });

  @override
  State<DetailReviewPage> createState() => _DetailReviewPageState();
}

class _DetailReviewPageState extends AccessReviewItemWidget<DetailReviewPage> {
  final ReviewService _reviewService = locator<ReviewService>();
  final GlobalKey<EditReviewContentWidgetState> _reviewContentKey = GlobalKey<EditReviewContentWidgetState>();
  final GlobalKey<EditStarRateWidgetState> _reviewStarRateKey = GlobalKey<EditStarRateWidgetState>();

  late Future<Map<String, dynamic>> _detailReviewPageFuture;

  @override
  void initState() {
    super.initState();
    _detailReviewPageFuture = initDetailReviewPageFuture();
  }

  Future<Map<String, dynamic>> initDetailReviewPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    ResponseDetailReview review = await _reviewService.fetchDetailReview(widget.reviewId);

    return {"review": review};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My review detail"),
        flexibleSpace: appBarColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailReviewPageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "리뷰 상세 데이터 불러오기..");
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                setState(() {
                  _detailReviewPageFuture = initDetailReviewPageFuture();
                });
              });
            } else if (error is RefreshTokenExpiredError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ForceLogoutDialog.show(context);
              });
              return const SizedBox.shrink();
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget();
            } else {
              return Center(child: Text("$error"));
            }
          } else {
            final data = snapshot.data!;
            ResponseDetailReview responseDetailProduct = data["review"];

            return SingleChildScrollView(
              child: Column(
                children: [
                  ReviewHeader(productName: widget.productName, subTitle: "상품 리뷰 상세보기"),
                  ReviewBody(
                    unfocusCallback: () => _reviewContentKey.currentState!.focusNode.unfocus(),
                    widgets: [
                      Container(
                        width: double.infinity,
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: commonContainerDecoration,
                        child: Row(
                          children: [
                            const Text(
                              "리뷰 수정 가능 횟수: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "(${responseDetailProduct.countForModify}/2)",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 90, 90, 90),
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                      EditReviewContentWidget(
                        key: _reviewContentKey,
                        beforeContent: responseDetailProduct.content,
                      ),
                      EditStarRateWidget(
                        key: _reviewStarRateKey,
                        beforeRating: responseDetailProduct.starRateScore,
                      ),
                      EditReviewMediaWidget(
                        beforeImageUrls: responseDetailProduct.imageUrls,
                        beforeVideoUrls: responseDetailProduct.videoUrls,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
