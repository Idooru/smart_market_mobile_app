import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../main/presentation/pages/navigation.page.dart';

class ForceLogoutDialog {
  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: ForceLogoutDialogWidget(parentContext: context),
      ),
    );
  }
}

class ForceLogoutDialogWidget extends StatefulWidget {
  final BuildContext parentContext;

  const ForceLogoutDialogWidget({
    super.key,
    required this.parentContext,
  });

  @override
  State<ForceLogoutDialogWidget> createState() => _ForceLogoutDialogWidgetState();
}

class _ForceLogoutDialogWidgetState extends State<ForceLogoutDialogWidget> {
  final SharedPreferences _db = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 30),
            const SizedBox(height: 5),
            const Text(
              "토큰이 만료되어 로그아웃합니다.",
              style: TextStyle(fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(widget.parentContext).pop();
                _db.remove("access-token");
                _db.remove("user-info");

                final state = widget.parentContext.findAncestorStateOfType<NavigationPageState>();
                state?.tapBottomNavigator(0); // index 1 = ProductSearchPage
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 200, 200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      size: 19,
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "로그아웃 하기",
                      style: TextStyle(
                        color: Color.fromARGB(255, 70, 70, 70),
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
