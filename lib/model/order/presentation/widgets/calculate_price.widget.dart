import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../account/domain/entities/account.entity.dart';

class CalculatePriceWidget extends StatefulWidget {
  const CalculatePriceWidget({super.key});

  @override
  State<CalculatePriceWidget> createState() => _CalculatePriceWidgetState();
}

class _CalculatePriceWidgetState extends State<CalculatePriceWidget> {
  Widget getCalculateLine(IconData icon, String title, int price) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.red,
        ),
        const SizedBox(width: 5),
        Text(
          "($title)",
          style: const TextStyle(color: Color.fromARGB(255, 120, 120, 120)),
        ),
        const SizedBox(width: 5),
        const Spacer(),
        Text(
          "${NumberFormat('#,###').format(price)}원",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget getStatusLine(String title, int totalPrice) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(width: 5),
        const Spacer(),
        Text(
          "${NumberFormat('#,###').format(totalPrice)}원",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderProvider>(
      builder: (BuildContext context, CreateOrderProvider provider, Widget? child) {
        String deliveryOption = provider.selectedDeliveryOption;
        int totalPrice = provider.cartTotalPrice;
        ResponseAccount mainAccount = provider.accounts.firstWhere((account) => account.isMainAccount);
        if (deliveryOption == "speed" || deliveryOption == "safe") totalPrice += 5000;
        return Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("금액 계산", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Column(
              children: provider.carts
                  .map(
                    (cart) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: getCalculateLine(Icons.add, cart.product.name, cart.totalPrice),
                    ),
                  )
                  .toList(),
            ),
            (() {
              String title = deliveryOption == "speed" ? "신속 배송비" : "안전 배송비";

              return deliveryOption == "speed" || deliveryOption == "safe"
                  ? getCalculateLine(
                      Icons.add,
                      title,
                      5000,
                    )
                  : const SizedBox.shrink();
            })(),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
            const SizedBox(height: 5),
            getStatusLine("총 결제 금액", totalPrice),
            const SizedBox(height: 20),
            getCalculateLine(Icons.account_balance, "계좌 금액", mainAccount.balance),
            getCalculateLine(Icons.remove, "결제 금액", totalPrice),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
            const SizedBox(height: 5),
            getStatusLine("계좌 잔액", mainAccount.balance - totalPrice),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
