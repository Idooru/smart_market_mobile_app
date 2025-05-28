import 'package:flutter/material.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';

class HandleNetworkErrorOnDialogDialog {
  static void show(BuildContext context, Object err) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: HandleNetworkErrorOnDialogWidget(err: err),
      ),
    );
  }
}

class HandleNetworkErrorOnDialogWidget extends StatefulWidget {
  final Object err;

  const HandleNetworkErrorOnDialogWidget({
    super.key,
    required this.err,
  });

  @override
  State<HandleNetworkErrorOnDialogWidget> createState() => _HandleNetworkErrorOnDialogState();
}

class _HandleNetworkErrorOnDialogState extends State<HandleNetworkErrorOnDialogWidget> with NetWorkHandler {
  late final String _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = branchErrorMessage(widget.err);
  }

  void pressConfirm() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250), // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(_errorMessage),
            ),
          ),
          SizedBox(
            height: 50,
            child: TextButton(
              onPressed: pressConfirm,
              child: const Text(
                "확인",
                style: TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
