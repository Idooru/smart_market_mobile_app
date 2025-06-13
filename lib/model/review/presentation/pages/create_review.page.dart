import 'package:flutter/material.dart';

import '../../../../core/themes/theme_data.dart';
import '../../../main/presentation/pages/navigation.page.dart';
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
  final bool isCreateCart;
  final void Function() updateCallback;
  final List<ProductIdentify> products;
  final String backRoute;

  const CreateReviewPageArgs({
    required this.isCreateCart,
    required this.products,
    required this.updateCallback,
    required this.backRoute,
  });
}

class CreateReviewPage extends StatefulWidget {
  final bool isCreateCart;
  final void Function() updateCallback;
  final List<ProductIdentify> products;
  final String backRoute;

  const CreateReviewPage({
    super.key,
    required this.isCreateCart,
    required this.updateCallback,
    required this.products,
    required this.backRoute,
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
            if (widget.isCreateCart) {
              widget.updateCallback();
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/home",
                (route) => false,
                arguments: const NavigationPageArgs(selectedIndex: 0),
              );
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName(widget.backRoute));
            }
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
          );
        }).toList(),
      ),
    );
  }
}
