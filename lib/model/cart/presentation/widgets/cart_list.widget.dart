import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/cart/presentation/widgets/cart_item.widget.dart';

import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../domain/entities/cart.entity.dart';
import '../../domain/service/cart.service.dart';

class CartListWidget extends StatefulWidget {
  final ResponseCarts carts;

  const CartListWidget({
    super.key,
    required this.carts,
  });

  @override
  State<CartListWidget> createState() => _CartListWidgetState();
}

class _CartListWidgetState extends State<CartListWidget> {
  final CartService _cartService = locator<CartService>();
  final RequestCarts defaultRequestCartsArgs = const RequestCarts(align: "DESC", column: "createdAt");
  late Future<ResponseCarts> _getCartsFuture;
  bool _isFirstRendering = true;

  void updateCarts(RequestCarts args) {
    setState(() {
      _getCartsFuture = _cartService.fetchCarts(args);
    });
  }

  GestureDetector getSortCartsButton() {
    return GestureDetector(
      onTap: pressSortCarts,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 230, 230, 230),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.sort, size: 15),
            Text("장바구니 정렬"),
          ],
        ),
      ),
    );
  }

  void pressSortCarts() {}

  Widget getPageElement(ResponseCarts carts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "내 장바구니 목록",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            getSortCartsButton(),
          ],
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "총 금액",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "${NumberFormat('#,###').format(carts.totalPrice)}원",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommonButtonBarWidget(
          icon: Icons.shopping_bag,
          title: "결제하기",
          backgroundColor: Colors.red,
          pressCallback: () {},
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
            updateCarts(defaultRequestCartsArgs);
            return FutureBuilder<ResponseCarts>(
              future: _getCartsFuture,
              builder: (BuildContext context, AsyncSnapshot<ResponseCarts> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      SizedBox(height: 30),
                      LoadingHandlerWidget(title: "장바구니 리스트 불러오기"),
                    ],
                  );
                } else if (snapshot.hasError) {
                  DioFailError err = snapshot.error as DioFailError;
                  if (err.message == "none connection") {
                    return Column(
                      children: [
                        const SizedBox(height: 25),
                        NetworkErrorHandlerWidget(reconnectCallback: () {
                          setState(() {
                            _getCartsFuture = _cartService.fetchCarts(defaultRequestCartsArgs);
                          });
                        }),
                        const SizedBox(height: 25),
                      ],
                    );
                  } else {
                    return const Column(
                      children: [
                        SizedBox(height: 25),
                        InternalServerErrorHandlerWidget(),
                        SizedBox(height: 25),
                      ],
                    );
                  }
                } else {
                  return getPageElement(snapshot.data!);
                }
              },
            );
          })();
  }
}
