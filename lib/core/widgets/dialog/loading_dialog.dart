import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';

class LoadingDialog {
  static void show(BuildContext context, {required String title}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: LoadingDialogWidget(title: title),
      ),
    );
  }
}

class LoadingDialogWidget extends StatelessWidget {
  final String title;

  const LoadingDialogWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: commonContainerDecoration,
      height: 70,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(color: Colors.black),
            ),
            const SizedBox(width: 15),
            Text(
              title.length > 20 ? '${title.substring(0, 15)}\n${title.substring(15)}' : title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
