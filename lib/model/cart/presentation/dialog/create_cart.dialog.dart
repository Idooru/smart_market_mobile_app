import 'package:flutter/material.dart';
import 'package:smart_market/model/cart/domain/entities/cart_product.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';

import '../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../common/mixin/edit_cart.mixin.dart';

class CreateCartDialog {
  static void show(BuildContext context, {required ResponseDetailProduct product, required void Function({required int quantity, required int totalPrice}) createCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CreateCartDialogWidget(
          responseDetailProduct: product,
          createCallback: createCallback,
        ),
      ),
    );
  }
}

class CreateCartDialogWidget extends StatefulWidget {
  final ResponseDetailProduct responseDetailProduct;
  final void Function({required int quantity, required int totalPrice}) createCallback;

  const CreateCartDialogWidget({
    super.key,
    required this.responseDetailProduct,
    required this.createCallback,
  });

  @override
  State<CreateCartDialogWidget> createState() => _CreateCartDialogWidgetState();
}

class _CreateCartDialogWidgetState extends State<CreateCartDialogWidget> with EditCart {
  @override
  void initState() {
    super.initState();
    productQuantity = 0;
    totalPrice = 0;
  }

  void pressIncrement() {
    if (productQuantity == 50) return;

    setState(() {
      productQuantity += 1;
      totalPrice = widget.responseDetailProduct.product.price * productQuantity;
    });
  }

  void pressDecrement() {
    if (productQuantity <= 1) return;

    setState(() {
      productQuantity -= 1;
      totalPrice = widget.responseDetailProduct.product.price * productQuantity;
    });
  }

  void pressCreate() {
    widget.createCallback(quantity: productQuantity, totalPrice: totalPrice);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return getCommonWidget(
      title: "장바구니 추가",
      product: CartProduct(
        name: widget.responseDetailProduct.product.name,
        price: widget.responseDetailProduct.product.price,
      ),
      pressIncrement: pressIncrement,
      pressDecrement: pressDecrement,
      doneButton: ConditionalButtonBarWidget(
        isValid: productQuantity != 0,
        icon: Icons.shopping_cart,
        backgroundColor: Colors.green,
        title: "추가하기",
        pressCallback: pressCreate,
      ),
    );
  }
}
