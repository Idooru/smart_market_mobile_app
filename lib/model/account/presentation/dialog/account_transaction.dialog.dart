import 'package:flutter/material.dart';

class AccountTransactionDialog {
  static void show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required void Function(int balance) transactionCallback,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AccountTransactionDialogWidget(
          icon: icon,
          title: title,
          transactionCallback: transactionCallback,
        ),
      ),
    );
  }
}

class AccountTransactionDialogWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final void Function(int balance) transactionCallback;

  const AccountTransactionDialogWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.transactionCallback,
  });

  @override
  State<AccountTransactionDialogWidget> createState() => _AccountTransactionDialogWidgetState();
}

class _AccountTransactionDialogWidgetState extends State<AccountTransactionDialogWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _balanceController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void detectInput(String? _) {
    setState(() {
      isValid = _balanceController.text.isNotEmpty;
    });
  }

  void pressTransaction() {
    widget.transactionCallback(int.parse(_balanceController.text));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250), // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                focusNode: _focusNode,
                controller: _balanceController,
                style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 90, 90, 90)),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onChanged: detectInput,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  prefixIcon: Icon(widget.icon),
                  hintText: "금액을 입력하세요",
                ),
              ),
            ),
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
                  onPressed: isValid ? pressTransaction : null,
                  child: Text(
                    widget.title,
                    style: const TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
