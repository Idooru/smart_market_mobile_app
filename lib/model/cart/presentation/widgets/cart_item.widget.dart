import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/cart.entity.dart';

class CartItemWidget extends StatefulWidget {
  final Cart cart;
  final void Function() updateCallback;

  const CartItemWidget({
    super.key,
    required this.cart,
    required this.updateCallback,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  void pressTrailingIcon() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 245, 245),
      ),
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.cart.product.imageUrls[0],
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 100,
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      widget.cart.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 50, 50, 50),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 188,
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text(
                            "${NumberFormat('#,###').format(widget.cart.product.price)}원",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 100, 100, 100),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: Color.fromARGB(255, 100, 100, 100),
                          ),
                        ),
                        Text(
                          "수량: ${widget.cart.quantity}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 100, 100, 100),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      "합계: ${NumberFormat('#,###').format(widget.cart.totalPrice)}원",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: 36,
          //   left: 100,
          //   child: ,
          // ),
          // Positioned(
          //   bottom: 10,
          //   left: 100,
          //   child: ,
          // ),
          Positioned(
            top: -5,
            right: -5,
            child: IconButton(
              constraints: const BoxConstraints(), // 크기 최소화
              icon: const Icon(Icons.more_vert, size: 18),
              onPressed: pressTrailingIcon,
            ),
          ),
        ],
      ),
    );
  }
}
