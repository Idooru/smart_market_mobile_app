import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/order/presentation/provider/after_create_order.provider.dart';

import '../../../cart/domain/entities/cart.entity.dart';

class PaymentProductItemWidget extends StatefulWidget {
  final int index;
  final Cart cart;
  final EdgeInsets margin;

  const PaymentProductItemWidget({
    super.key,
    required this.index,
    required this.cart,
    required this.margin,
  });

  @override
  State<PaymentProductItemWidget> createState() => PaymentProductItemWidgetState();
}

class PaymentProductItemWidgetState extends State<PaymentProductItemWidget> {
  bool isChecked = true;
  late CompleteCreateOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<CompleteCreateOrderProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReviewCartItem item = ReviewCartItem(isChecked: isChecked, cart: widget.cart);
      provider.appendIsCheckedList(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        provider.modifyIsCheckedList(isChecked, widget.index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 247, 247, 247),
        ),
        height: 45,
        margin: widget.margin,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.cart.product.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                widget.cart.product.category,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 120, 120, 120),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank),
            ),
          ],
        ),
      ),
    );
  }
}
