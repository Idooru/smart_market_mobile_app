import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/cart/presentation/widgets/cart_item.widget.dart';
import 'package:smart_market/model/order/presentation/pages/create_order.page.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../domain/entities/cart.entity.dart';
import '../../domain/service/cart.service.dart';
import '../dialog/sort_carts.dialog.dart';
import '../dialog/warn_delete_all_carts.dialog.dart';

class CartListWidget extends StatefulWidget {
  final String address;
  final ResponseCarts carts;
  final List<ResponseAccount> accounts;

  const CartListWidget({
    super.key,
    required this.address,
    required this.carts,
    required this.accounts,
  });

  @override
  State<CartListWidget> createState() => CartListWidgetState();
}

class CartListWidgetState extends State<CartListWidget> {
  final CartService _cartService = locator<CartService>();
  final RequestCarts defaultRequestCartsArgs = const RequestCarts(align: "DESC", column: "createdAt");
  late Future<ResponseCarts> _getCartsFuture;
  bool _isFirstRendering = true;

  @override
  void initState() {
    super.initState();
    _getCartsFuture = _cartService.fetchCarts(defaultRequestCartsArgs);
  }

  void updateCarts(RequestCarts args) {
    setState(() {
      _getCartsFuture = _cartService.fetchCarts(args);
    });
  }

  GestureDetector getButton({
    required void Function() pressCallback,
    required IconData icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: pressCallback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        decoration: quickButtonDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon, size: 15),
            const SizedBox(width: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget getPageElement(ResponseCarts carts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: carts.cartRaws.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getButton(
                      pressCallback: () {
                        WarnDeleteAllCartsDialog.show(
                          context,
                          updateCallback: () => updateCarts(defaultRequestCartsArgs),
                        );
                      },
                      icon: Icons.delete,
                      title: '장바구니 전부삭제',
                    ),
                    getButton(
                      pressCallback: () => SortCartsDialog.show(context, updateCallback: updateCarts),
                      icon: Icons.sort,
                      title: '장바구니 정렬',
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: carts.cartRaws.isEmpty
              ? const Center(
                  child: Text(
                    "장바구니가 비어있습니다.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 90, 90, 90),
                      fontSize: 15,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: carts.cartRaws.length,
                  itemBuilder: (context, index) => CartItemWidget(
                    cart: carts.cartRaws[index],
                    updateCallback: () => updateCarts(defaultRequestCartsArgs),
                  ),
                ),
        ),
        Row(
          children: [
            const Text(
              "총 금액",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "${formatNumber(carts.totalPrice)}원",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Consumer<CreateOrderProvider>(
          builder: (BuildContext context, CreateOrderProvider provider, Widget? child) {
            return ConditionalButtonBarWidget(
              icon: Icons.shopping_bag,
              title: "결제 주문하기",
              backgroundColor: Colors.red,
              pressCallback: () {
                NavigatorState navigator = Navigator.of(context);

                provider.setCarts(carts.cartRaws);
                provider.setCartTotalPrice(carts.totalPrice);
                provider.setAccounts(widget.accounts);

                navigator.pushNamed(
                  "/create_order",
                  arguments: CreateOrderPageArgs(
                    address: widget.address,
                    isCreateCart: true,
                    updateCallback: () => updateCarts(defaultRequestCartsArgs),
                    backRoute: "",
                  ),
                );
              },
              isValid: carts.cartRaws.isNotEmpty,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstRendering
        ? Builder(
            builder: (BuildContext context) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstRendering = false);
              return getPageElement(widget.carts);
            },
          )
        : (() {
            return FutureBuilder<ResponseCarts>(
              future: _getCartsFuture,
              builder: (BuildContext context, AsyncSnapshot<ResponseCarts> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingHandlerWidget(title: "장바구니 리스트 불러오기");
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  if (error is ConnectionError) {
                    return NetworkErrorHandlerWidget(reconnectCallback: () {
                      setState(() {
                        _getCartsFuture = _cartService.fetchCarts(defaultRequestCartsArgs);
                      });
                    });
                  } else if (error is DioFailError) {
                    return const InternalServerErrorHandlerWidget();
                  } else {
                    return Center(child: Text("$error"));
                  }
                } else {
                  return getPageElement(snapshot.data!);
                }
              },
            );
          })();
  }
}
