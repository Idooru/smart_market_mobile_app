import 'package:flutter/material.dart';
import 'package:smart_market/model/review/presentation/dialog/warn_go_out_review.dialog.dart';

import '../../../../core/themes/theme_data.dart';
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
            WarnGoOutReviewDialog.show(context, backRoute: widget.backRoute);
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
