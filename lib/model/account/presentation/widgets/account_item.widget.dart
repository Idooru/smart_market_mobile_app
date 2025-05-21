import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/entities/account_transaction.entity.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/account/presentation/dialog/account_transaction.dialog.dart';
import 'package:smart_market/model/account/presentation/dialog/handle_transaction_error.dialog.dart';

class AccountItemWidget extends StatefulWidget {
  final ResponseAccount account;
  final void Function() updateCallback;

  const AccountItemWidget({
    super.key,
    required this.account,
    required this.updateCallback,
  });

  @override
  State<AccountItemWidget> createState() => _AccountItemWidgetState();
}

class _AccountItemWidgetState extends State<AccountItemWidget> {
  final AccountService _accountService = locator<AccountService>();

  void HandleAccountTransactionError(DioFailError err) {
    Navigator.of(context);
    HandleAccountTransactionErrorDialog.show(context, err: err);
  }

  void pressDeposit() {
    Future<void> deposit(int balance) async {
      RequestAccountTransaction args = RequestAccountTransaction(
        id: widget.account.id,
        balance: balance,
      );

      try {
        await _accountService.deposit(args);
        widget.updateCallback();
      } on DioFailError catch (err) {
        HandleAccountTransactionError(err);
      }
    }

    Navigator.of(context).pop();
    AccountTransactionDialog.show(
      context,
      icon: Icons.attach_money,
      title: '입금하기',
      transactionCallback: deposit,
    );
  }

  void pressWithDraw() async {
    Future<void> withDraw(int balance) async {
      RequestAccountTransaction args = RequestAccountTransaction(
        id: widget.account.id,
        balance: balance,
      );

      try {
        await _accountService.withdraw(args);
        widget.updateCallback();
      } on DioFailError catch (err) {
        HandleAccountTransactionError(err);
      }
    }

    Navigator.of(context).pop();
    AccountTransactionDialog.show(
      context,
      icon: Icons.payment,
      title: '출금하기',
      transactionCallback: withDraw,
    );
  }

  void pressSetMainAccount() {
    NavigatorState navigator = Navigator.of(context);
    // ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    navigator.pop();
  }

  void pressDeleteAccount() {
    NavigatorState navigator = Navigator.of(context);
    // ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    navigator.pop();
  }

  void pressTrailingIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: pressDeposit,
                child: const ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text("입금하기"),
                ),
              ),
              GestureDetector(
                onTap: pressWithDraw,
                child: const ListTile(
                  leading: Icon(Icons.payment),
                  title: Text("출금하기"),
                ),
              ),
              widget.account.isMainAccount
                  ? Container()
                  : GestureDetector(
                      onTap: pressSetMainAccount,
                      child: const ListTile(
                        leading: Icon(Icons.account_balance_wallet),
                        title: Text("주 사용 계좌 설정"),
                      ),
                    ),
              GestureDetector(
                onTap: pressDeleteAccount,
                child: const ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text("계좌 삭제"),
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
    return Container(
      width: double.infinity,
      height: 95,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 245, 245),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              "${widget.account.bank} ${widget.account.accountNumber}",
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              widget.account.isMainAccount ? Icons.check_circle_outline : Icons.circle_outlined,
              color: widget.account.isMainAccount ? Colors.red : Colors.black,
            ),
          ),
          Positioned(
            top: 35,
            left: 10,
            child: Text(
              "${NumberFormat('#,###').format(widget.account.balance)} 원",
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            child: Text(
              "${parseDate(widget.account.createdAt)}에 계좌 등록됨",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 120, 120, 120),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: IconButton(
              constraints: const BoxConstraints(), // 크기 최소화
              icon: const Icon(Icons.more_vert, size: 15),
              onPressed: pressTrailingIcon,
            ),
          ),
        ],
      ),
    );
  }
}
