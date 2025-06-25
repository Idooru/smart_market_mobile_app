import 'package:flutter/material.dart';

import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../core/widgets/dialog/warn_dialog.dart';

class InvitationLoginDialog {
  static void show(BuildContext context) {
    WarnDialog.show(
      context,
      title: "로그인이 필요한 서비스입니다.",
      buttons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommonButtonBarWidget(
            title: "로그인 하기",
            backgroundColor: Colors.blueAccent,
            pressCallback: () {
              NavigatorState navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushNamed("/login");
            },
          ),
        ),
        CommonButtonBarWidget(
          backgroundColor: const Color.fromARGB(255, 120, 120, 120),
          title: "취소",
          pressCallback: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
