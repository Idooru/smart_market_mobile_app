import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/format_number.dart';

import '../../domain/entities/cart_product.entity.dart';

mixin EditCart {
  late int productQuantity;
  late int totalPrice;

  Widget getCommonWidget({
    required String title,
    required CartProduct product,
    required void Function() pressIncrement,
    required void Function() pressDecrement,
    required Widget doneButton,
  }) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                            "이름: ${product.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 50, 50, 50),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "가격: ${formatNumber(product.price)}원",
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
                          width: 55,
                          height: 45,
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
                          width: 55,
                          height: 45,
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
                      "합계: ${formatNumber(totalPrice)}원",
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            doneButton,
          ],
        ),
      ),
    );
  }
}
