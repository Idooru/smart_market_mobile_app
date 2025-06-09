import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/cart/domain/entities/cart_product.entity.dart';

import '../../common/state/edit_cart.state.dart';
import '../../domain/entities/cart.entity.dart';

class ModifyCartDialog {
  static void show(context, {required Cart cart, required void Function({required int quantity, required int totalPrice}) modifyCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ModifyCartDialogWidget(
          cart: cart,
          modifyCallback: modifyCallback,
        ),
      ),
    );
  }
}

class ModifyCartDialogWidget extends StatefulWidget {
  final Cart cart;
  final void Function({required int quantity, required int totalPrice}) modifyCallback;

  const ModifyCartDialogWidget({
    super.key,
    required this.cart,
    required this.modifyCallback,
  });

  @override
  State<ModifyCartDialogWidget> createState() => _ModifyCartDialogWidgetState();
}

class _ModifyCartDialogWidgetState extends EditCartState<ModifyCartDialogWidget> {
  @override
  void initState() {
    super.initState();
    productQuantity = widget.cart.quantity;
    totalPrice = widget.cart.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    CartProduct product = CartProduct(
      name: widget.cart.product.name,
      price: widget.cart.product.price,
    );

    return getCommonWidget(
      title: "장바구니 수정",
      product: CartProduct(
        name: widget.cart.product.name,
        price: widget.cart.product.price,
      ),
      pressIncrement: () => pressIncrement(product),
      pressDecrement: () => pressDecrement(product),
      doneButton: CommonButtonBarWidget(
        icon: Icons.edit,
        backgroundColor: Colors.green,
        title: "수정하기",
        pressCallback: () {
          widget.modifyCallback(quantity: productQuantity, totalPrice: totalPrice);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
