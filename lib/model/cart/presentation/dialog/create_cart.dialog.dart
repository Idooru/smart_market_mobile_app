import 'package:flutter/material.dart';
import 'package:smart_market/model/cart/domain/entities/cart_product.entity.dart';

import '../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../common/state/edit_cart.state.dart';

class CreateCartDialog {
  static void show(
    BuildContext context, {
    required CartProduct product,
    required void Function({required int quantity, required int totalPrice}) createCallback,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CreateCartDialogWidget(
          product: product,
          createCallback: createCallback,
        ),
      ),
    );
  }
}

class CreateCartDialogWidget extends StatefulWidget {
  final CartProduct product;
  final void Function({required int quantity, required int totalPrice}) createCallback;

  const CreateCartDialogWidget({
    super.key,
    required this.product,
    required this.createCallback,
  });

  @override
  State<CreateCartDialogWidget> createState() => _CreateCartDialogWidgetState();
}

class _CreateCartDialogWidgetState extends EditCartState<CreateCartDialogWidget> {
  @override
  void initState() {
    super.initState();
    productQuantity = 1;
    totalPrice = widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    return getCommonWidget(
      title: "장바구니",
      product: CartProduct(
        name: widget.product.name,
        price: widget.product.price,
      ),
      pressIncrement: () => pressIncrement(widget.product),
      pressDecrement: () => pressDecrement(widget.product),
      doneButton: ConditionalButtonBarWidget(
        isValid: productQuantity != 0,
        icon: Icons.shopping_cart,
        backgroundColor: Colors.blue,
        title: "장바구니 담기",
        pressCallback: () {
          widget.createCallback(
            quantity: productQuantity,
            totalPrice: totalPrice,
          );
        },
      ),
    );
  }
}
