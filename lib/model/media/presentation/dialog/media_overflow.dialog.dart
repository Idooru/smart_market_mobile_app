import 'package:flutter/material.dart';

class MediaOverflowDialog {
  static void show(BuildContext context, {required String title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: MediaOverflowDialogWidget(title: title),
      ),
    );
  }
}

class MediaOverflowDialogWidget extends StatelessWidget {
  final String title;

  const MediaOverflowDialogWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(
              "$title 업로드 개수를",
              style: const TextStyle(fontSize: 17),
            ),
            const Text(
              "초과하였습니다.",
              style: TextStyle(fontSize: 17),
            ),
            Center(
              child: TextButton(
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Color.fromARGB(255, 70, 70, 70),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
