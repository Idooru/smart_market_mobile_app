import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/order/presentation/provider/after_create_order.provider.dart';

import '../../../../core/common/network_handler.mixin.dart';
import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/errors/refresh_token_expired.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../core/widgets/common/conditional_button_bar.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../user/presentation/dialog/force_logout.dialog.dart';
import '../../domain/entities/create_order.entity.dart';
import '../../domain/service/order.service.dart';
import '../widgets/payment_product_item.widget.dart';

class CompleteCreateOrderPageArgs {
  final List<Cart> carts;
  final RequestCreateOrder args;
  final bool isCreateCart;
  final void Function() updateCallback;

  const CompleteCreateOrderPageArgs({
    required this.carts,
    required this.args,
    required this.isCreateCart,
    required this.updateCallback,
  });
}

class CompleteCreateOrderPage extends StatefulWidget {
  final List<Cart> carts;
  final RequestCreateOrder requestCreateOrderArgs;
  final bool isCreateCart;
  final void Function() updateCallback;

  const CompleteCreateOrderPage({
    super.key,
    required this.carts,
    required this.requestCreateOrderArgs,
    required this.isCreateCart,
    required this.updateCallback,
  });

  @override
  State<CompleteCreateOrderPage> createState() => _CompleteCreateOrderPageState();
}

class _CompleteCreateOrderPageState extends State<CompleteCreateOrderPage> with NetWorkHandler {
  final OrderService _orderService = locator<OrderService>();

  late Future<Map<String, dynamic>> _afterCreateOrderPageFuture;
  late CompleteCreateOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<CompleteCreateOrderProvider>();
    _afterCreateOrderPageFuture = initCompleteCreateOrderPageFuture();
  }

  @override
  void dispose() {
    provider.clearAll();
    super.dispose();
  }

  Future<Map<String, dynamic>> initCompleteCreateOrderPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    await _orderService.createOrder(widget.requestCreateOrderArgs);

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _afterCreateOrderPageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "결제 주문 생성하기..");
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Widget widget;
            if (error is ConnectionError) {
              widget = NetworkErrorHandlerWidget(reconnectCallback: () {
                setState(() {
                  _afterCreateOrderPageFuture = initCompleteCreateOrderPageFuture();
                });
              });
            } else if (error is RefreshTokenExpiredError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ForceLogoutDialog.show(context);
              });
              widget = const SizedBox.shrink();
            } else if (error is DioFailError) {
              widget = const InternalServerErrorHandlerWidget();
            } else {
              widget = Center(child: Text("$error"));
            }

            return Column(children: [
              const SizedBox(height: 200),
              widget,
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("뒤로가기"),
              ),
            ]);
          } else {
            return Consumer<CompleteCreateOrderProvider>(
              builder: (BuildContext context, CompleteCreateOrderProvider provider, Widget? child) {
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 70),
                        const SizedBox(
                          height: 70,
                          child: Center(
                            child: Text(
                              "결제 주문이 완료되었습니다.",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              "구매한 상품에 리뷰를 남겨보세요.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 60, 60),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 230,
                          padding: const EdgeInsets.all(10),
                          decoration: commonContainerDecoration,
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.carts.asMap().entries.map((entry) {
                                final index = entry.key;
                                final cart = entry.value;
                                EdgeInsets margin = index != widget.carts.length - 1 ? const EdgeInsets.only(bottom: 10) : const EdgeInsets.only(bottom: 0);

                                return PaymentProductItemWidget(index: index, cart: cart, margin: margin);
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        (() {
                          bool isValid = provider.isCheckedList.any((item) => item.isChecked);
                          return ConditionalButtonBarWidget(
                            icon: isValid ? Icons.reviews : Icons.warning_amber,
                            title: isValid ? "리뷰 작성하기" : "리뷰를 남길 상품을 선택하세요.",
                            backgroundColor: Colors.blue,
                            pressCallback: () {
                              List<ReviewCartItem> reviewCartItems = provider.isCheckedList.where((item) => item.isChecked).toList();
                              List<String> productIds = reviewCartItems.map((item) => item.cart.product.id).toList();
                            },
                            isValid: isValid,
                          );
                        })(),
                        const SizedBox(height: 7),
                        CommonButtonBarWidget(
                          title: "나중에 작성 할게요!",
                          backgroundColor: const Color.fromARGB(255, 120, 120, 120),
                          pressCallback: () {
                            if (widget.isCreateCart) {
                              widget.updateCallback();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              // final state = context.findAncestorStateOfType<NavigationPageState>();
                              // state?.tapBottomNavigator(0);
                            } else {
                              Navigator.of(context).popUntil(ModalRoute.withName("/detail_product"));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
