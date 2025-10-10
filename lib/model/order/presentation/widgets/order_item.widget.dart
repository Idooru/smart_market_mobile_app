import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/widgets/common/common_border.widget.dart';
import 'package:smart_market/core/widgets/dialog/handle_network_error.dialog.dart';
import 'package:smart_market/core/widgets/dialog/loading_dialog.dart';
import 'package:smart_market/model/order/domain/entities/order.entity.dart';
import 'package:smart_market/model/order/domain/service/order.service.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../common/util/parse_delivery_option.dart';
import '../../domain/entities/transaction_status.entity.dart';
import '../pages/display_payment.page.dart';

class OrderItemWidget extends StatefulWidget {
  final ResponseOrders responseOrders;
  final EdgeInsets margin;

  const OrderItemWidget({
    super.key,
    required this.responseOrders,
    required this.margin,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  final OrderService _orderService = locator<OrderService>();
  late TransactionStatus _status;

  @override
  void initState() {
    super.initState();
    _status = TransactionStatus.generate(widget.responseOrders.order.transactionStatus);
  }

  Widget CategoryItem({required String title, required List<Widget> widgets}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black, fontSize: 19)),
        const CommonBorder(
          width: 0.5,
          color: Color.fromARGB(255, 160, 160, 160),
        ),
        const SizedBox(height: 5),
        ...widgets,
      ],
    );
  }

  void pressTrailingIcon(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        NavigatorState navigator = Navigator.of(context);
        ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  navigator.pop();
                  navigator.pushNamed(
                    "/display_payment",
                    arguments: DisplayPaymentPageArgs(
                      responseOrders: widget.responseOrders,
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text("결제 내역 보기"),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  navigator.pop();
                  String orderId = widget.responseOrders.order.id;

                  LoadingDialog.show(context, title: "주문 취소 중..");

                  _orderService.cancelOrder(orderId).then((_) {
                    setState(() {
                      _status = TransactionStatus.generate("cancel");
                    });
                    navigator.pop();
                  }).catchError((err) {
                    navigator.pop();
                    HandleNetworkErrorDialog.show(context, err);
                  });
                },
                child: const ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text("주문 취소 하기"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => pressTrailingIcon(context),
      child: Container(
        width: double.infinity,
        margin: widget.margin,
        decoration: commonContainerDecoration,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: <Widget>[
                  CategoryItem(title: "주문 정보", widgets: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.5),
                      child: Row(
                        children: [
                          const Text("주문 일시: "),
                          Text(
                            widget.responseOrders.order.createdAt,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 100, 100, 100),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.5),
                      child: Builder(
                        builder: (BuildContext context) {
                          return Row(
                            children: [
                              const Text("주문 상태: "),
                              Text(
                                _status.text,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: _status.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  CategoryItem(
                    title: "배송 정보",
                    widgets: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.5),
                        child: Row(
                          children: [
                            const Text("배송 옵션: "),
                            const SizedBox(width: 3),
                            Text(
                              parseDeliveryOption(widget.responseOrders.order.deliveryOption),
                              style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 100, 100, 100)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("배송 주소: "),
                            const SizedBox(width: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                widget.responseOrders.order.deliveryAddress,
                                style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 100, 100, 100)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CategoryItem(
                    title: "금액 정보",
                    widgets: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.5),
                        child: Row(
                          children: [
                            const Text("상품 비용: "),
                            const SizedBox(width: 3),
                            Text(
                              "${formatNumber(widget.responseOrders.order.totalPrice - widget.responseOrders.order.surtaxPrice)}원",
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.5),
                        child: Row(
                          children: [
                            const Text("추가 비용: "),
                            const SizedBox(width: 3),
                            Text(
                              "${formatNumber(widget.responseOrders.order.surtaxPrice)}원",
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.5),
                        child: Row(
                          children: [
                            const Text("총합 금액: "),
                            const SizedBox(width: 3),
                            Text(
                              "${formatNumber(widget.responseOrders.order.totalPrice)}원",
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              top: -3,
              right: -5,
              child: IconButton(
                constraints: const BoxConstraints(), // 크기 최소화
                icon: const Icon(Icons.more_vert, size: 18),
                onPressed: () => pressTrailingIcon(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
