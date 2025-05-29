import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/cart/domain/entities/cart_product.entity.dart';

import '../../common/mixin/edit_cart.mixin.dart';
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

class _ModifyCartDialogWidgetState extends State<ModifyCartDialogWidget> with EditCart {
  @override
  void initState() {
    super.initState();
    productQuantity = widget.cart.quantity;
    totalPrice = widget.cart.totalPrice;
  }

  void pressIncrement() {
    if (productQuantity == 50) return;

    setState(() {
      productQuantity += 1;
      totalPrice = widget.cart.product.price * productQuantity;
    });
  }

  void pressDecrement() {
    if (productQuantity == 1) return;

    setState(() {
      productQuantity -= 1;
      totalPrice = widget.cart.product.price * productQuantity;
    });
  }

  void pressModify() {
    widget.modifyCallback(quantity: productQuantity, totalPrice: totalPrice);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return getCommonWidget(
      title: "장바구니 수정",
      product: CartProduct(
        name: widget.cart.product.name,
        price: widget.cart.product.price,
      ),
      pressIncrement: pressIncrement,
      pressDecrement: pressDecrement,
      doneButton: CommonButtonBarWidget(
        icon: Icons.edit,
        backgroundColor: Colors.green,
        title: "수정하기",
        pressCallback: pressModify,
      ),
    );
  }
}
