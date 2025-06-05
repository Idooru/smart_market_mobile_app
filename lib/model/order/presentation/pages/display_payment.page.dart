import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/model/order/presentation/widgets/payment_item.widget.dart';

import '../../common/util/parse_delivery_option.dart';
import '../../domain/entities/order.entity.dart';

class DisplayPaymentPageArgs {
  final ResponseOrders responseOrders;

  const DisplayPaymentPageArgs({
    required this.responseOrders,
  });
}

class DisplayPaymentPage extends StatefulWidget {
  final ResponseOrders responseOrders;

  const DisplayPaymentPage({
    super.key,
    required this.responseOrders,
  });

  @override
  State<DisplayPaymentPage> createState() => _DisplayPaymentPageState();
}

class _DisplayPaymentPageState extends State<DisplayPaymentPage> {
  Widget getSurtaxItem(String deliveryOption, int price) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 245, 245),
      ),
      child: Center(
        child: Text(
          "${parseDeliveryOption(deliveryOption)} 비용: ${formatNumber(price)}원",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Payment"),
        centerTitle: false,
        flexibleSpace: Container(
          color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  ...widget.responseOrders.payments.asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      Payment payment = entry.value;
                      bool hasPlusIcon = index + 1 != widget.responseOrders.payments.length || widget.responseOrders.order.surtaxPrice != 0;

                      return PaymentItemWidget(
                        payment: payment,
                        hasPlusIcon: hasPlusIcon,
                      );
                    },
                  ),
                  widget.responseOrders.order.surtaxPrice != 0
                      ? getSurtaxItem(
                          widget.responseOrders.order.deliveryOption,
                          widget.responseOrders.order.surtaxPrice,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 230, 230, 230),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "총 금액",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    "${formatNumber(widget.responseOrders.order.totalPrice)}원",
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
