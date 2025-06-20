import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/widgets/common/common_border.widget.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/order/domain/entities/order.entity.dart';
import 'package:smart_market/model/order/presentation/pages/display_payment.page.dart';

import '../../common/util/parse_delivery_option.dart';

class OrderItemWidget extends StatelessWidget {
  final ResponseOrders responseOrders;
  final EdgeInsets margin;

  const OrderItemWidget({
    super.key,
    required this.responseOrders,
    required this.margin,
  });

  IconData parseTransactionStatusIcon(String transactionStatus) {
    if (transactionStatus == "success") {
      return Icons.check;
    } else if (transactionStatus == "fail") {
      return Icons.cancel;
    }
    return Icons.import_contacts;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: margin,
      decoration: commonContainerDecoration,
      child: Column(
        children: <Widget>[
          CategoryItem(title: "주문 정보", widgets: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1.5),
              child: Row(
                children: [
                  const Text("주문 일시: "),
                  Text(
                    responseOrders.order.createdAt,
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
                  const Text("주문 상태: "),
                  const SizedBox(width: 3),
                  Icon(
                    parseTransactionStatusIcon(responseOrders.order.transactionStatus),
                    color: const Color.fromARGB(255, 100, 100, 100),
                    size: 15,
                  ),
                ],
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
                      parseDeliveryOption(responseOrders.order.deliveryOption),
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
                        responseOrders.order.deliveryAddress,
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
                      "${formatNumber(responseOrders.order.totalPrice - responseOrders.order.surtaxPrice)}원",
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
                      "${formatNumber(responseOrders.order.surtaxPrice)}원",
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
                      "${formatNumber(responseOrders.order.totalPrice)}원",
                      style: const TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                    responseOrders: responseOrders,
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
