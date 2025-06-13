import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/review/presentation/pages/create_review.page.dart';
import 'package:smart_market/model/review/presentation/widgets/edit/edit_review_media.widget.dart';
import 'package:smart_market/model/review/presentation/widgets/edit/edit_star_rate.widget.dart';

import '../../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../../../../core/widgets/common/focus_edit.widget.dart';
import '../../provider/edit_review.provider.dart';
import '../edit/edit_review_content.widget.dart';
import '../edit/edit_review_title.widget.dart';

class CreateReviewItemWidget extends StatefulWidget {
  final ProductIdentify product;
  final bool isLastWidget;
  final PageController controller;

  const CreateReviewItemWidget({
    super.key,
    required this.product,
    required this.isLastWidget,
    required this.controller,
  });

  @override
  State<CreateReviewItemWidget> createState() => _CreateReviewItemWidgetState();
}

class _CreateReviewItemWidgetState extends State<CreateReviewItemWidget> {
  final GlobalKey<EditReviewTitleState> _reviewTitleKey = GlobalKey<EditReviewTitleState>();
  final GlobalKey<EditReviewContentWidgetState> _reviewContentKey = GlobalKey<EditReviewContentWidgetState>();
  final GlobalKey<EditStarRateWidgetState> _reviewStarRateKey = GlobalKey<EditStarRateWidgetState>();
  final GlobalKey<EditReviewMediaWidgetState> _reviewMediaKey = GlobalKey<EditReviewMediaWidgetState>();

  late EditReviewProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<EditReviewProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditReviewProvider>(
      builder: (BuildContext context, EditReviewProvider provider, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 40,
                color: const Color.fromARGB(255, 250, 250, 250),
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(fontSize: 17),
                      ),
                      const Text(
                        " 상품 리뷰 작성",
                        style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    FocusEditWidget<EditReviewTitleState>(
                      editWidgetKey: _reviewTitleKey,
                      editWidget: EditReviewTitleWidget(key: _reviewTitleKey),
                    ),
                    EditReviewContentWidget(key: _reviewContentKey, isLastWidget: true),
                    EditStarRateWidget(key: _reviewStarRateKey),
                    EditReviewMediaWidget(key: _reviewMediaKey),
                    (() {
                      bool isValid = provider.isReviewTitleValid && provider.isReviewContentValid;

                      return ConditionalButtonBarWidget(
                        icon: Icons.reviews,
                        title: "리뷰 작성하기",
                        isValid: isValid,
                        pressCallback: () {
                          if (widget.isLastWidget) {
                          } else {
                            widget.controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      );
                    })(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
