import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';

import '../../../../core/themes/theme_data.dart';
import '../../../main/presentation/pages/navigation.page.dart';
import '../dialog/go_out_review.dialog.dart';
import '../widgets/item/create_review_item.widget.dart';

class ProductIdentify {
  final String id;
  final String name;

  const ProductIdentify({
    required this.id,
    required this.name,
  });
}

class CreateReviewPageArgs {
  final List<ProductIdentify> products;
  final String? backRoute;

  const CreateReviewPageArgs({
    required this.products,
    this.backRoute,
  });
}

class CreateReviewPage extends StatefulWidget {
  final List<ProductIdentify> products;
  final String? backRoute;

  const CreateReviewPage({
    super.key,
    required this.products,
    this.backRoute,
  });

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create review"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            GoOutReviewDialog.show(
              context,
              title: '작성중인 리뷰는 저장되지 않습니다._뒤로 가시겠습니까?',
              buttons: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CommonButtonBarWidget(
                    icon: Icons.arrow_back_ios,
                    title: "뒤로 가기",
                    pressCallback: () {
                      if (widget.backRoute != null) {
                        Navigator.of(context).popUntil(ModalRoute.withName(widget.backRoute!));
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/home",
                          (route) => false,
                          arguments: const NavigationPageArgs(selectedIndex: 0),
                        );
                      }
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
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        flexibleSpace: appBarColor,
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.products.asMap().entries.map((entry) {
          int index = entry.key;
          ProductIdentify product = entry.value;
          bool isLastWidget = index == widget.products.length - 1;
          return CreateReviewItemWidget(
            product: product,
            isLastWidget: isLastWidget,
            controller: controller,
            backRoute: widget.backRoute,
          );
        }).toList(),
      ),
    );
  }
}
