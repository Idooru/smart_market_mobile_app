import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../order/presentation/pages/create_order.page.dart';
import '../../common/state/edit_cart.state.dart';
import '../../domain/entities/cart.entity.dart';
import '../../domain/entities/cart_product.entity.dart';

class PayNowDialog {
  static void show(
    BuildContext context, {
    required CartProduct product,
    required Future<ResponseCarts?> Function({required int quantity, required int totalPrice}) payNowCallback,
    required String address,
    required List<ResponseAccount> accounts,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: PayNowDialogWidget(
          product: product,
          payNowCallback: payNowCallback,
          address: address,
          accounts: accounts,
        ),
      ),
    );
  }
}

class PayNowDialogWidget extends StatefulWidget {
  final CartProduct product;
  final Future<ResponseCarts?> Function({required int quantity, required int totalPrice}) payNowCallback;
  final String address;
  final List<ResponseAccount> accounts;

  const PayNowDialogWidget({
    super.key,
    required this.product,
    required this.payNowCallback,
    required this.address,
    required this.accounts,
  });

  @override
  State<PayNowDialogWidget> createState() => _PayNowDialogWidgetState();
}

class _PayNowDialogWidgetState extends EditCartState<PayNowDialogWidget> {
  @override
  void initState() {
    super.initState();
    productQuantity = 1;
    totalPrice = widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderProvider>(
      builder: (BuildContext context, CreateOrderProvider provider, Widget? child) {
        return getCommonWidget(
          title: "바로 구매",
          product: CartProduct(
            name: widget.product.name,
            price: widget.product.price,
          ),
          pressIncrement: () => pressIncrement(widget.product),
          pressDecrement: () => pressDecrement(widget.product),
          doneButton: ConditionalButtonBarWidget(
            isValid: productQuantity != 0,
            icon: Icons.payment,
            backgroundColor: Colors.orange,
            title: "바로 구매하기",
            pressCallback: () async {
              NavigatorState navigator = Navigator.of(context);
              ResponseCarts? result = await widget.payNowCallback(quantity: productQuantity, totalPrice: totalPrice);

              if (result == null) return;

              provider.setCarts(result.cartRaws);
              provider.setCartTotalPrice(result.totalPrice);
              provider.setAccounts(widget.accounts);

              navigator.pushNamed(
                "/create_order",
                arguments: CreateOrderPageArgs(
                  address: widget.address,
                  isCreateCart: false,
                  updateCallback: () {},
                ),
              );
            },
          ),
        );
      },
    );
  }
}
