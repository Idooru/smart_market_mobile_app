import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../cart/common/const/default_request_carts_args.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../cart/domain/entities/create_cart.entity.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../pages/create_order.page.dart';

class WarnAlreadyHasCartsDialog {
  static void show(
    BuildContext context, {
    required RequestCreateCart createCartArgs,
    required String address,
    required List<ResponseAccount> accounts,
    String? backRoute,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: WarnAlreadyHasCartsDialogWidget(
          createCartArgs: createCartArgs,
          accounts: accounts,
          address: address,
          backRoute: backRoute,
        ),
      ),
    );
  }
}

class WarnAlreadyHasCartsDialogWidget extends StatelessWidget {
  final RequestCreateCart createCartArgs;
  final List<ResponseAccount> accounts;
  final String address;
  final String? backRoute;
  final CartService _cartService = locator<CartService>();

  WarnAlreadyHasCartsDialogWidget({
    super.key,
    required this.createCartArgs,
    required this.address,
    required this.accounts,
    this.backRoute,
  });

  Future<void> payWithCarts(BuildContext context, CreateOrderProvider provider) async {
    NavigatorState navigator = Navigator.of(context);
    navigator.pop();

    await _cartService.createCart(createCartArgs);
    ResponseCarts responseCarts = await _cartService.fetchCarts(defaultRequestCartsArgs);

    provider.setCarts(responseCarts.cartRaws);
    provider.setCartTotalPrice(responseCarts.totalPrice);
    provider.setAccounts(accounts);

    navigator.pushNamed(
      "/create_order",
      arguments: CreateOrderPageArgs(
        address: address,
        backRoute: backRoute,
      ),
    );
  }

  Future<void> payWithoutCarts(BuildContext context, CreateOrderProvider provider) async {
    NavigatorState navigator = Navigator.of(context);
    navigator.pop();

    await _cartService.createCart(createCartArgs);
    ResponseCarts responseCarts = await _cartService.fetchCarts(defaultRequestCartsArgs);

    List<Cart> payNowCarts = responseCarts.cartRaws.where((cart) => cart.isPayNow).toList();
    provider.setCarts(payNowCarts);
    provider.setCartTotalPrice(responseCarts.totalPrice);
    provider.setAccounts(accounts);

    navigator.pushNamed(
      "/create_order",
      arguments: CreateOrderPageArgs(
        address: address,
        backRoute: backRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderProvider>(
      builder: (BuildContext context, CreateOrderProvider provider, Widget? child) {
        return Container(
          decoration: commonContainerDecoration,
          height: 240,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "이미 카트에 상품이 존재합니다.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Text(
                "계속 결제 하시겠습니까?",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
              CommonButtonBarWidget(
                title: "카트에 있는 상품과 같이 결제",
                pressCallback: () => payWithCarts(context, provider),
              ),
              const SizedBox(height: 7),
              CommonButtonBarWidget(
                backgroundColor: Colors.green,
                title: "카트에 있는 상품과 따로 결제",
                pressCallback: () => payWithoutCarts(context, provider),
              ),
              const SizedBox(height: 7),
              CommonButtonBarWidget(
                backgroundColor: const Color.fromARGB(255, 120, 120, 120),
                title: "결제 취소",
                pressCallback: () => Navigator.of(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
