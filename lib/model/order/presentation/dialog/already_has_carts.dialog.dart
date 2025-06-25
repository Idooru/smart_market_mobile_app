import 'package:flutter/material.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../core/widgets/dialog/warn_dialog.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../cart/common/const/default_request_carts_args.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../cart/domain/entities/create_cart.entity.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../pages/create_order.page.dart';

class AlreadyHasCartsDialog {
  static final CartService _cartService = locator<CartService>();

  static void show(
    BuildContext context, {
    required RequestCreateCart createCartArgs,
    required CreateOrderProvider provider,
    required List<ResponseAccount> accounts,
    required String address,
    final String? backRoute,
  }) {
    WarnDialog.show(
      context,
      title: "이미 장바구니에 상품이 존재합니다._계속 결제 하시겠습니까?",
      buttons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonButtonBarWidget(
            title: "카트에 있는 상품과 같이 결제",
            pressCallback: () async {
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
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonButtonBarWidget(
            backgroundColor: Colors.green,
            title: "카트에 있는 상품과 따로 결제",
            pressCallback: () async {
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
            },
          ),
        ),
        CommonButtonBarWidget(
          backgroundColor: const Color.fromARGB(255, 120, 120, 120),
          title: "결제 취소",
          pressCallback: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
