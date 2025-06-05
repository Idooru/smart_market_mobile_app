import 'package:flutter/material.dart';

import '../../domain/entities/order.entity.dart';

class OrderFilterDialog {
  static void show(BuildContext context, {required void Function(RequestOrders args) updateCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderFilterDialogWidget(updateCallback: updateCallback),
      ),
    );
  }
}

class OrderFilterDialogWidget extends StatefulWidget {
  final void Function(RequestOrders args) updateCallback;

  const OrderFilterDialogWidget({
    super.key,
    required this.updateCallback,
  });

  @override
  State<OrderFilterDialogWidget> createState() => _OrderFilterDialogState();
}

class _OrderFilterDialogState extends State<OrderFilterDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
