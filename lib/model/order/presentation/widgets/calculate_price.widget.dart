import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/widgets/common/common_border.widget.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../account/domain/entities/account.entity.dart';
import '../../../cart/domain/entities/cart.entity.dart';

class CalculatePriceWidget extends StatefulWidget {
  const CalculatePriceWidget({super.key});

  @override
  State<CalculatePriceWidget> createState() => _CalculatePriceWidgetState();
}

class _CalculatePriceWidgetState extends State<CalculatePriceWidget> {
  Widget getProductLine(Cart cart) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 230, 230, 230),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                "(${cart.product.name})",
                style: const TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
              ),
              const Spacer(),
              Text(
                "${formatNumber(cart.product.price)} x ${cart.quantity}",
                style: const TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              const Icon(
                Icons.add,
                size: 20,
                color: Colors.red,
              ),
              const SizedBox(width: 3),
              Text(
                "${formatNumber(cart.totalPrice)}원",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSurtaxLine(String title) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 2, color: const Color.fromARGB(255, 222, 102, 102)),
      ),
      child: Row(
        children: [
          Text(
            "($title)",
            style: const TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
          ),
          const Spacer(),
          const Icon(
            Icons.add,
            size: 20,
            color: Colors.red,
          ),
          const SizedBox(width: 3),
          Text(
            "${formatNumber(5000)}원",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget getCalculateLine(IconData? icon, String title, int price) {
    return Row(
      children: [
        Text(
          "($title)",
          style: const TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
        ),
        const Spacer(),
        Icon(
          icon,
          size: 20,
          color: Colors.red,
        ),
        const SizedBox(width: 3),
        Text(
          "${formatNumber(price)}원",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget getTotalPriceLine(String title, int totalPrice) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(width: 5),
        const Spacer(),
        Text(
          "${formatNumber(totalPrice)}원",
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: commonContainerDecoration,
              child: Column(
                children: [
                  Column(
                    children: provider.carts.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final cart = entry.value;
                        final isLast = index == provider.carts.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                          child: getProductLine(cart),
                        );
                      },
                    ).toList(),
                  ),
                  (() {
                    String title = deliveryOption == "speed" ? "신속 배송비" : "안전 배송비";
                    return deliveryOption == "speed" || deliveryOption == "safe" ? getSurtaxLine(title) : const SizedBox.shrink();
                  })(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: CommonBorder(),
                  ),
                  getTotalPriceLine("총 결제 금액", totalPrice),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: commonContainerDecoration,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        getCalculateLine(null, "계좌 금액", mainAccount.balance),
                        getCalculateLine(Icons.remove, "결제 금액", totalPrice),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: CommonBorder(),
                  ),
                  getTotalPriceLine("계좌 잔액", mainAccount.balance - totalPrice),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
