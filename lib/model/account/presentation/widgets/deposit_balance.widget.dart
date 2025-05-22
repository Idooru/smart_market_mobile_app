import 'package:flutter/material.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';

class DepositWidget extends StatefulWidget {
  const DepositWidget({super.key});

  @override
  State<DepositWidget> createState() => DepositBalanceWidgetState();
}

class DepositBalanceWidgetState extends EditWidgetState<DepositWidget> with InputWidget {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController depositController = TextEditingController();

  @override
  FocusNode get focusNode => throw UnimplementedError();

  @override
  void dispose() {
    _focusNode.dispose();
    depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("계좌번호"),
        getEditWidget(
          TextField(
            focusNode: _focusNode,
            controller: depositController,
            keyboardType: TextInputType.number,
            style: getInputTextStyle(),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.credit_card, color: Color.fromARGB(255, 60, 60, 60)),
              hintText: "입금할 잔액을 입력하세요.",
            ),
          ),
        ),
      ],
    );
  }
}
