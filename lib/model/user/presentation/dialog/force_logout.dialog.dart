import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../core/widgets/dialog/warn_dialog.dart';
import '../../../main/presentation/pages/navigation.page.dart';

class ForceLogoutDialog {
  static void show(BuildContext context) {
    WarnDialog.show(
      context,
      title: "인증 수단이 만료되어 로그아웃합니다.",
      buttons: [
        CommonButtonBarWidget(
          icon: Icons.logout,
          title: "로그아웃 하기",
          backgroundColor: const Color.fromARGB(255, 120, 120, 120),
          pressCallback: () {
            final SharedPreferences db = locator<SharedPreferences>();
            Navigator.of(context).pop();
            db.remove("access-token");
            db.remove("user-info");

            Navigator.of(context).pushNamedAndRemoveUntil(
              "/home",
              (route) => false,
              arguments: const NavigationPageArgs(selectedIndex: 0),
            );
          },
        ),
      ],
    );
  }
}
