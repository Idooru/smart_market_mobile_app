import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';

import '../../../../core/widgets/dialog/handle_network_error.dialog.dart';
import '../../../../core/widgets/dialog/warn_dialog.dart';

class DeleteAllCartsDialog {
  static final CartService _cartService = locator<CartService>();

  static void show(BuildContext context, {required void Function() updateCallback}) {
    WarnDialog.show(
      context,
      title: "장바구니를 전부 삭제하시겠습니까?",
      buttons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonButtonBarWidget(
            title: "전부 삭제하기",
            backgroundColor: Colors.redAccent,
            icon: Icons.delete,
            pressCallback: () async {
              NavigatorState navigator = Navigator.of(context);
              ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

              navigator.pop();
              try {
                await _cartService.deleteAllCarts();
                updateCallback();
                scaffoldMessenger.showSnackBar(getSnackBar("장바구니를 전부 삭제합니다."));
              } catch (err) {
                HandleNetworkErrorDialog.show(context, err);
              }
            },
          ),
        ),
        CommonButtonBarWidget(
          backgroundColor: const Color.fromARGB(255, 120, 120, 120),
          title: "삭제 취소",
          pressCallback: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
