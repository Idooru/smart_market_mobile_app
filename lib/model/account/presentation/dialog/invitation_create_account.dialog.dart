import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/canel_button_bar.widget.dart';
import 'package:smart_market/core/widgets/dialog/warn_dialog.dart';

import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../pages/create_account.page.dart';

class InvitationCreateAccountDialog {
  static void show(BuildContext context, {String? backRoute}) {
    NavigatorState navigator = Navigator.of(context);

    WarnDialog.show(
      context,
      title: "현재 보유중인 계좌가 없습니다._계좌를 생성하시겠습니까?",
      buttons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonButtonBarWidget(
            title: Text(
              "계좌 생성 하기",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            pressCallback: () {
              navigator.pop();
              navigator.pushNamed(
                "/create_account",
                arguments: CreateAccountPageArgs(
                  isAccountsEmpty: true,
                  backRoute: backRoute,
                ),
              );
            },
          ),
        ),
        CancelButtonBarWidget(),
      ],
    );
  }
}
