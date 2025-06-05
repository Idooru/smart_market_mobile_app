import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/format_number.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/cart/domain/entities/modify_cart.entity.dart';
import 'package:smart_market/model/cart/presentation/dialog/modify_cart.dialog.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/utils/get_snackbar.dart';
import '../../../../core/widgets/dialog/handle_network_error_on_dialog.dialog.dart';
import '../../../product/presentation/pages/detail_product.page.dart';
import '../../domain/entities/cart.entity.dart';
import '../../domain/service/cart.service.dart';

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
  final CartService _cartService = locator<CartService>();

  void handleCartError(Object err) {
    HandleNetworkErrorOnDialogDialog.show(context, err);
  }

  void pressShowProductDetail() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
      "/detail_product",
      arguments: DetailProductPageArgs(productId: widget.cart.product.id),
    );
  }

  Future<void> pressModifyCart() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    Future<void> modifyCart({required int quantity, required int totalPrice}) async {
      RequestModifyCart args = RequestModifyCart(
        cartId: widget.cart.id,
        productId: widget.cart.product.id,
        quantity: quantity,
        totalPrice: totalPrice,
      );

      try {
        await _cartService.modifyCart(args);
        widget.updateCallback();
        scaffoldMessenger.showSnackBar(getSnackBar("해당 장바구니를 수정하였습니다."));
      } catch (err) {
        handleCartError(err);
      }
    }

    Navigator.of(context).pop();
    ModifyCartDialog.show(
      context,
      cart: widget.cart,
      modifyCallback: modifyCart,
    );
  }

  Future<void> pressDeleteCart() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _cartService.deleteCart(widget.cart.id);
      widget.updateCallback();
      scaffoldMessenger.showSnackBar(getSnackBar("해당 장바구니를 삭제하였습니다."));
      navigator.pop();
    } catch (err) {
      navigator.pop();
      handleCartError(err);
    }
  }

  void pressTrailingIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: pressShowProductDetail,
                child: const ListTile(
                  leading: Icon(Icons.open_in_new),
                  title: Text("상품 상세 보기"),
                ),
              ),
              GestureDetector(
                onTap: pressModifyCart,
                child: const ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("장바구니 수정"),
                ),
              ),
              GestureDetector(
                onTap: pressDeleteCart,
                child: const ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("장바구니 삭제"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: pressTrailingIcon,
      child: Container(
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
                          fontSize: 17,
                          color: Color.fromARGB(255, 50, 50, 50),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        "합계: ${formatNumber(widget.cart.totalPrice)}원",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 188,
                      child: Row(
                        children: [
                          SizedBox(
                            child: Text(
                              "${formatNumber(widget.cart.product.price)}원",
                              style: const TextStyle(
                                // fontSize: 16,
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
                              // fontSize: 14,
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
                        "생성일: ${parseDate(widget.cart.createdAt)}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 100, 100, 100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
      ),
    );
  }
}
