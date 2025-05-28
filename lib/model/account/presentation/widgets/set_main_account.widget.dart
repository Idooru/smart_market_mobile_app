import 'package:flutter/material.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';

class SetMainAccountWidget extends StatefulWidget {
  final bool isAccountsEmpty;

  const SetMainAccountWidget({
    super.key,
    required this.isAccountsEmpty,
  });

  @override
  State<SetMainAccountWidget> createState() => SetMainAccountWidgetState();
}

class SetMainAccountWidgetState extends State<SetMainAccountWidget> with InputWidget {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isAccountsEmpty;
  }

  void pressCheckBox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getTitle("주 사용 계좌 설정"),
        const Spacer(),
        IconButton(
          onPressed: widget.isAccountsEmpty ? null : pressCheckBox,
          icon: Icon(isChecked ? Icons.check_box_outlined : Icons.check_box_outline_blank_sharp),
        ),
      ],
    );
  }
}
