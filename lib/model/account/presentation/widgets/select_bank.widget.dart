import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/account/presentation/state/create_account.provider.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';

class SelectBankWidget extends StatefulWidget {
  const SelectBankWidget({super.key});

  @override
  State<SelectBankWidget> createState() => SelectBankWidgetState();
}

class SelectBankWidgetState extends State<SelectBankWidget> with EditWidget {
  late CreateAccountProvider _provider;

  bool _isValid = false;
  String selectedBank = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<CreateAccountProvider>();
  }

  void pressBank(String bank) {
    setState(() {
      selectedBank = bank;
      _isValid = true;
    });

    _provider.setIsBankValid(true);
    Navigator.of(context).pop();
  }

  void pressSelectBank() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => pressBank("국민은행"),
                child: const ListTile(
                  title: Center(child: Text("국민은행")),
                ),
              ),
              GestureDetector(
                onTap: () => pressBank("농협은행"),
                child: const ListTile(
                  title: Center(child: Text("농협은행")),
                ),
              ),
              GestureDetector(
                onTap: () => pressBank("우리은행"),
                child: const ListTile(
                  title: Center(child: Text("우리은행")),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("은행"),
        getEditWidget(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 15),
              Icon(
                Icons.account_balance,
                size: 19,
                color: _isValid ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextButton(
                  onPressed: pressSelectBank,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    !_isValid ? "은행 선택" : selectedBank,
                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
