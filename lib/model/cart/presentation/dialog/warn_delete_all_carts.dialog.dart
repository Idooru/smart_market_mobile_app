import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';

class WarnDeleteAllCartsDialog {
  static void show(BuildContext context, {required void Function() updateCallback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: WarnDeleteAllCartsDialogWidget(
          updateCallback: updateCallback,
        ),
      ),
    );
  }
}

class WarnDeleteAllCartsDialogWidget extends StatefulWidget {
  final void Function() updateCallback;

  const WarnDeleteAllCartsDialogWidget({
    super.key,
    required this.updateCallback,
  });

  @override
  State<WarnDeleteAllCartsDialogWidget> createState() => _WarnDeleteAllCartsDialogWidgetState();
}

class _WarnDeleteAllCartsDialogWidgetState extends State<WarnDeleteAllCartsDialogWidget> {
  final CartService _cartService = locator<CartService>();

  Future<void> pressYes(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    navigator.pop();
    try {
      await _cartService.deleteAllCarts();
      widget.updateCallback();
      scaffoldMessenger.showSnackBar(getSnackBar("장바구니를 전부 삭제합니다."));
    } on DioException catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "장바구니를 전부 삭제하시겠습니까?",
                style: TextStyle(fontSize: 17),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 200, 200, 200),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text("아니요"),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => pressYes(context),
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text("네"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
