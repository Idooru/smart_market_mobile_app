import 'package:flutter/material.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';

class HandleNetworkErrorDialog {
  static void show(BuildContext context, Object err) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: HandleNetworkErrorDialogWidget(err: err),
      ),
    );
  }
}

class HandleNetworkErrorDialogWidget extends StatelessWidget with NetWorkHandler {
  final Object err;

  const HandleNetworkErrorDialogWidget({
    super.key,
    required this.err,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonDialogDecoration,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 30),
          const SizedBox(height: 5),
          ...branchErrorMessage(err).replaceAll(".", "._").split("_").map(
                (title) => Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
          const SizedBox(height: 10),
          CommonButtonBarWidget(
            title: "확인",
            backgroundColor: const Color.fromARGB(255, 120, 120, 120),
            pressCallback: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
