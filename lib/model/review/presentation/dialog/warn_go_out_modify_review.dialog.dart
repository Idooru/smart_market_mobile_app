import 'package:flutter/material.dart';

import '../../../main/presentation/pages/navigation.page.dart';

class WarnGoOutModifyReviewDialog {
  static void show(BuildContext context, {String? backRoute}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: WarnGoOutModifyReviewDialogWidget(
          backRoute: backRoute,
        ),
      ),
    );
  }
}

class WarnGoOutModifyReviewDialogWidget extends StatelessWidget {
  final String? backRoute;

  const WarnGoOutModifyReviewDialogWidget({
    super.key,
    this.backRoute,
  });

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
              "리뷰가 일부 수정되었습니다.",
              style: TextStyle(fontSize: 17),
            ),
            const Text(
              "뒤로 가시겠습니까?",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    onPressed: () {
                      if (backRoute != null) {
                        Navigator.of(context).popUntil(ModalRoute.withName(backRoute!));
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/home",
                          (route) => false,
                          arguments: const NavigationPageArgs(selectedIndex: 0),
                        );
                      }
                    },
                    child: const Text(
                      "뒤로가기",
                      style: TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
