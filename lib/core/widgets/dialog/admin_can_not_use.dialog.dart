import 'package:flutter/material.dart';

class AdminCanNotUseDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const Dialog(
        child: AdminCantNotUseDialogWidget(),
      ),
    );
  }
}

class AdminCantNotUseDialogWidget extends StatelessWidget {
  const AdminCantNotUseDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 115,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 30),
            const SizedBox(height: 5),
            const Text("관리자 권한은 사용할 수 없습니다.", style: TextStyle(fontSize: 17)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "확인",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
