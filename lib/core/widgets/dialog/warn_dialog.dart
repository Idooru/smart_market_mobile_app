import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';

import '../common/common_button_bar.widget.dart';

class WarnDialog {
  static void show(
    BuildContext context, {
    required String title,
    required List<Widget> buttons,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: WarnDialogWidget(
          title: title,
          buttons: buttons,
        ),
      ),
    );
  }
}

class WarnDialogWidget extends StatelessWidget {
  final String title;
  final List<Widget> buttons;

  const WarnDialogWidget({
    super.key,
    required this.title,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonDialogDecoration,
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
            if (buttons.isNotEmpty) ...buttons,
            if (buttons.isEmpty)
              CommonButtonBarWidget(
                title: "확인",
                backgroundColor: const Color.fromARGB(255, 120, 120, 120),
                pressCallback: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}
