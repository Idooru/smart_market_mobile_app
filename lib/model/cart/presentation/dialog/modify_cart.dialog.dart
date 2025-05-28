import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';

import '../../domain/entities/cart.entity.dart';

class ModifyCartDialog {
  static void show(context, {required Cart cart, required void Function({required int quantity, required int totalPrice}) modifyCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ModifyCartDialogWidget(
          cart: cart,
          modifyCallback: modifyCallback,
        ),
      ),
    );
  }
}

class ModifyCartDialogWidget extends StatefulWidget {
  final Cart cart;
  final void Function({required int quantity, required int totalPrice}) modifyCallback;

  const ModifyCartDialogWidget({
    super.key,
    required this.cart,
    required this.modifyCallback,
  });

  @override
  State<ModifyCartDialogWidget> createState() => _ModifyCartDialogWidgetState();
}

class _ModifyCartDialogWidgetState extends State<ModifyCartDialogWidget> {
  late int productQuantity;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    productQuantity = widget.cart.quantity;
    totalPrice = widget.cart.totalPrice;
  }

  void pressIncrement() {
    setState(() {
      productQuantity += 1;
      totalPrice = widget.cart.product.price * productQuantity;
    });
  }

  void pressDecrement() {
    setState(() {
      productQuantity -= 1;
      totalPrice = widget.cart.product.price * productQuantity;
    });
  }

  void pressModify() {
    widget.modifyCallback(quantity: productQuantity, totalPrice: totalPrice);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "장바구니 수정",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "이름: ${widget.cart.product.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 50, 50, 50),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "가격: ${NumberFormat('#,###').format(widget.cart.product.price)}원",
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: Icon(
                Icons.close_sharp,
                size: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: pressDecrement,
                        child: Container(
                          width: 75,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$productQuantity",
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: pressIncrement,
                        child: Container(
                          width: 75,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: 3, height: 17, color: Colors.black),
                  const SizedBox(width: 3),
                  Container(width: 3, height: 17, color: Colors.black),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      "합계: ${NumberFormat('#,###').format(totalPrice)}원",
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            CommonButtonBarWidget(
              icon: Icons.edit,
              backgroundColor: Colors.green,
              title: "수정하기",
              pressCallback: pressModify,
            ),
          ],
        ),
      ),
    );
  }
}
