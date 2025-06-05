import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/widgets/common/common_border.widget.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/order/domain/entities/order.entity.dart';
import 'package:smart_market/model/order/presentation/pages/display_payment.page.dart';

import '../../common/util/parse_delivery_option.dart';

class OrderItemWidget extends StatefulWidget {
  final ResponseOrders responseOrders;

  const OrderItemWidget({
    super.key,
    required this.responseOrders,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  IconData parseTransactionStatusIcon(String transactionStatus) {
    if (transactionStatus == "success") {
      return Icons.check;
    } else if (transactionStatus == "fail") {
      return Icons.cancel;
    }
    return Icons.import_contacts;
  }

  Widget getCategoryItem({required String title, required List<Widget> widgets}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black, fontSize: 19)),
        const CommonBorder(
          width: 1,
          color: Color.fromARGB(255, 160, 160, 160),
        ),
        const SizedBox(height: 5),
        ...widgets,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 245, 245),
      ),
      child: Column(
        children: <Widget>[
          getCategoryItem(title: "주문 정보", widgets: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1.5),
              child: Row(
                children: [
                  const Text("일시: "),
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
              child: Row(
                children: [
                  const Text("상태: "),
                  const SizedBox(width: 3),
                  Icon(
                    parseTransactionStatusIcon(widget.responseOrders.order.transactionStatus),
                    color: const Color.fromARGB(255, 100, 100, 100),
                    size: 15,
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          getCategoryItem(
            title: "배송 정보",
            widgets: [
              Padding(
                padding: const EdgeInsets.only(bottom: 1.5),
                child: Row(
                  children: [
                    const Text("옵션: "),
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
                    const Text("주소: "),
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
          getCategoryItem(
            title: "금액 정보",
            widgets: [
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
                    const Text("총 금액: "),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CommonButtonBarWidget(
              icon: Icons.shopping_bag,
              title: "결제 내역 보기",
              backgroundColor: const Color.fromARGB(255, 100, 100, 100),
              pressCallback: () {
                Navigator.of(context).pushNamed(
                  "/display_payment",
                  arguments: DisplayPaymentPageArgs(
                    responseOrders: widget.responseOrders,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
