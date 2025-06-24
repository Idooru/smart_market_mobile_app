import 'package:flutter/material.dart';

class WarnGoOutReviewDialog {
  static void show(
    BuildContext context, {
    required String title,
    required List<Widget> buttons,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: WarnGoOutReviewDialogWidget(
          title: title,
          buttons: buttons,
        ),
      ),
    );
  }
}

class WarnGoOutReviewDialogWidget extends StatelessWidget {
  final String title;
  final List<Widget> buttons;

  const WarnGoOutReviewDialogWidget({
    super.key,
    required this.title,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, size: 30),
            const SizedBox(height: 5),
            ...title.split("_").map(
                  (title) => Text(
                    title,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
            const SizedBox(height: 10),
            ...buttons,
          ],
        ),
      ),
    );
  }
}
