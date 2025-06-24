import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/model/review/domain/service/review.service.dart';
import 'package:smart_market/model/review/presentation/pages/create_review.page.dart';
import 'package:smart_market/model/review/presentation/widgets/edit/edit_star_rate.widget.dart';
import 'package:smart_market/model/review/presentation/widgets/item/access_review_item.widget.dart';

import '../../../../../core/utils/get_it_initializer.dart';
import '../../../../../core/utils/get_snackbar.dart';
import '../../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../../../../core/widgets/common/focus_edit.widget.dart';
import '../../../../../core/widgets/dialog/loading_dialog.dart';
import '../../../../main/presentation/pages/navigation.page.dart';
import '../../../../media/presentation/provider/review_image.provider.dart';
import '../../../../media/presentation/provider/review_video.provider.dart';
import '../../../domain/entity/create_review.entity.dart';
import '../../provider/edit_review.provider.dart';
import '../edit/edit_review_content.widget.dart';
import '../edit/edit_review_media.widget.dart';

class CreateReviewItemWidget extends StatefulWidget {
  final ProductIdentify product;
  final bool isLastWidget;
  final PageController controller;
  final String? backRoute;

  const CreateReviewItemWidget({
    super.key,
    required this.product,
    required this.isLastWidget,
    required this.controller,
    this.backRoute,
  });

  @override
  State<CreateReviewItemWidget> createState() => _CreateReviewItemWidgetState();
}

class _CreateReviewItemWidgetState extends AccessReviewItemWidget<CreateReviewItemWidget> with NetWorkHandler {
  final ReviewService _reviewService = locator<ReviewService>();
  final GlobalKey<EditReviewContentWidgetState> _reviewContentKey = GlobalKey<EditReviewContentWidgetState>();
  final GlobalKey<EditStarRateWidgetState> _reviewStarRateKey = GlobalKey<EditStarRateWidgetState>();

  bool _hasError = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<EditReviewProvider>(
      builder: (BuildContext context, EditReviewProvider provider, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ReviewHeader(productName: widget.product.name, subTitle: "상품 리뷰 작성"),
              ReviewBody(
                unfocusCallback: () => _reviewContentKey.currentState!.focusNode.unfocus(),
                widgets: [
                  FocusEditWidget<EditReviewContentWidgetState>(
                    editWidgetKey: _reviewContentKey,
                    editWidget: EditReviewContentWidget(key: _reviewContentKey),
                  ),
                  EditStarRateWidget(key: _reviewStarRateKey),
                  const EditReviewMediaWidget(),
                  Consumer2<ReviewImageProvider, ReviewVideoProvider>(builder: (
                    BuildContext context,
                    ReviewImageProvider reviewImageProvider,
                    ReviewVideoProvider reviewVideoProvider,
                    Widget? child,
                  ) {
                    return ConditionalButtonBarWidget(
                      icon: Icons.reviews,
                      title: "리뷰 작성하기",
                      isValid: provider.isReviewContentValid,
                      pressCallback: () async {
                        NavigatorState navigator = Navigator.of(context);
                        ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

                        RequestCreateReview args = RequestCreateReview(
                          productId: widget.product.id,
                          content: _reviewContentKey.currentState!.reviewContentController.text,
                          starRateScore: _reviewStarRateKey.currentState!.selectedRating,
                          reviewImages: reviewImageProvider.reviewImages,
                          reviewVideos: reviewVideoProvider.reviewVideos,
                        );

                        try {
                          LoadingDialog.show(context, title: "리뷰 생성 중..");

                          await _reviewService.createReview(args);
                          reviewImageProvider.clearAll();
                          reviewVideoProvider.clearAll();
                          scaffoldMessenger.showSnackBar(getSnackBar("${widget.product.name}상품의 리뷰를 작성하였습니다."));

                          if (!widget.isLastWidget) {
                            navigator.pop();
                            widget.controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          } else {
                            if (widget.backRoute != null) {
                              navigator.popUntil(ModalRoute.withName(widget.backRoute!));
                            } else {
                              navigator.pushNamedAndRemoveUntil(
                                "/home",
                                (route) => false,
                                arguments: const NavigationPageArgs(selectedIndex: 0),
                              );
                            }
                          }
                        } catch (err) {
                          setState(() {
                            _hasError = true;
                            _errorMessage = branchErrorMessage(err);
                          });
                          navigator.pop();
                        }
                      },
                    );
                  }),
                  if (_hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: getErrorMessageWidget(_errorMessage),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
