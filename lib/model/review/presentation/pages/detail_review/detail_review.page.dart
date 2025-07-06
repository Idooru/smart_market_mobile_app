import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/check_jwt_duration.dart';
import 'package:smart_market/model/media/presentation/provider/review_image.provider.dart';
import 'package:smart_market/model/media/presentation/provider/review_video.provider.dart';
import 'package:smart_market/model/review/domain/entity/detail_review.entity.dart';
import 'package:smart_market/model/review/domain/service/review.service.dart';
import 'package:smart_market/model/review/presentation/provider/edit_review.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/access_review_item.widget.dart';

import '../../../../../core/errors/connection_error.dart';
import '../../../../../core/errors/dio_fail.error.dart';
import '../../../../../core/errors/refresh_token_expired.error.dart';
import '../../../../../core/themes/theme_data.dart';
import '../../../../../core/utils/get_it_initializer.dart';
import '../../../../../core/utils/get_snackbar.dart';
import '../../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../../../../core/widgets/dialog/loading_dialog.dart';
import '../../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../../user/presentation/dialog/force_logout.dialog.dart';
import '../../../domain/entity/modify_review.entity.dart';
import '../../dialog/go_out_review.dialog.dart';
import '../../widgets/edit/edit_review_content.widget.dart';
import '../../widgets/edit/edit_review_media.widget.dart';
import '../../widgets/edit/edit_star_rate.widget.dart';

class DetailReviewPageArgs {
  final String reviewId;
  final String productId;
  final String productName;
  final String backRoute;

  const DetailReviewPageArgs({
    required this.reviewId,
    required this.productId,
    required this.productName,
    required this.backRoute,
  });
}

class DetailReviewPage extends StatefulWidget {
  final DetailReviewPageArgs args;

  const DetailReviewPage({
    super.key,
    required this.args,
  });

  @override
  State<DetailReviewPage> createState() => _DetailReviewPageState();
}

class _DetailReviewPageState extends AccessReviewItemWidget<DetailReviewPage> {
  final ReviewService _reviewService = locator<ReviewService>();
  final GlobalKey<EditReviewContentWidgetState> _reviewContentKey = GlobalKey<EditReviewContentWidgetState>();
  final GlobalKey<EditStarRateWidgetState> _reviewStarRateKey = GlobalKey<EditStarRateWidgetState>();

  late Future<Map<String, dynamic>> _detailReviewPageFuture;

  bool hasInitialized = false;

  @override
  void initState() {
    super.initState();

    _detailReviewPageFuture = initDetailReviewPageFuture();
  }

  Future<Map<String, dynamic>> initDetailReviewPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    ResponseDetailReview review = await _reviewService.fetchDetailReview(widget.args.reviewId);

    return {"review": review};
  }

  Future<void> pressModifyReview(
    ReviewImageProvider reviewImageProvider,
    ReviewVideoProvider reviewVideoProvider,
  ) async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    RequestModifyReview args = RequestModifyReview(
      reviewId: widget.args.reviewId,
      productId: widget.args.productId,
      content: _reviewContentKey.currentState!.reviewContentController.text,
      starRateScore: _reviewStarRateKey.currentState!.selectedRating,
      reviewImages: reviewImageProvider.reviewImages,
      reviewVideos: reviewVideoProvider.reviewVideos,
    );

    try {
      LoadingDialog.show(context, title: "리뷰 수정 중..");

      await _reviewService.modifyReview(args);
      reviewImageProvider.clearAll();
      reviewVideoProvider.clearAll();
      scaffoldMessenger.showSnackBar(getSnackBar("${widget.args.productName}상품의 리뷰를 수정하였습니다."));

      navigator.pop();
      navigator.pop(true);
    } catch (err) {
      navigator.pop();
      debugPrint("리뷰 수정 에러: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return Consumer2<ReviewImageProvider, ReviewVideoProvider>(
              builder: (BuildContext context, ReviewImageProvider reviewImageProvider, ReviewVideoProvider reviewVideoProvider, Widget? child) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("My review detail"),
                    flexibleSpace: appBarColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: IconButton(
                        onPressed: () {
                          String beforeContent = responseDetailProduct.content;
                          String currentContent = _reviewContentKey.currentState!.reviewContentController.text;
                          bool isNotSameContent = beforeContent != currentContent;

                          if (isNotSameContent && responseDetailProduct.countForModify == 0) {
                            Navigator.of(context).pop();
                          } else if (isNotSameContent) {
                            GoOutReviewDialog.show(
                              context,
                              title: "리뷰가 일부 수정되었습니다._저장 하시겠습니까?",
                              buttons: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: CommonButtonBarWidget(
                                    icon: Icons.save,
                                    title: "저장하고 뒤로가기",
                                    backgroundColor: Colors.green,
                                    pressCallback: () {
                                      Navigator.of(context).pop();
                                      pressModifyReview(reviewImageProvider, reviewVideoProvider);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: CommonButtonBarWidget(
                                    icon: Icons.arrow_back_ios,
                                    title: "저장하지 않고 뒤로가기",
                                    pressCallback: () {
                                      Navigator.of(context).popUntil(ModalRoute.withName(widget.args.backRoute));
                                    },
                                  ),
                                ),
                                CommonButtonBarWidget(
                                  backgroundColor: const Color.fromARGB(255, 120, 120, 120),
                                  title: "취소",
                                  pressCallback: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ReviewHeader(productName: widget.args.productName, subTitle: "상품 리뷰 상세보기"),
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
                            Consumer<EditReviewProvider>(
                              builder: (
                                BuildContext context,
                                EditReviewProvider provider,
                                Widget? child,
                              ) {
                                return ConditionalButtonBarWidget(
                                  icon: Icons.edit,
                                  title: "리뷰 수정하기",
                                  isValid: provider.isReviewContentValid && responseDetailProduct.countForModify != 0,
                                  pressCallback: () => pressModifyReview(reviewImageProvider, reviewVideoProvider),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
