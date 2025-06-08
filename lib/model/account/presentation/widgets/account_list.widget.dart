import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/account/presentation/dialog/sort_account.dialog.dart';
import 'package:smart_market/model/account/presentation/pages/create_account.page.dart';
import 'package:smart_market/model/account/presentation/widgets/account_item.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/widgets/common/common_border.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';

class AccountListWidget extends StatefulWidget {
  final List<ResponseAccount> accounts;

  const AccountListWidget({
    super.key,
    required this.accounts,
  });

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  final AccountService _accountService = locator<AccountService>();
  final RequestAccounts defaultRequestAccountsArgs = const RequestAccounts(align: "DESC", column: "createdAt");
  late Future<List<ResponseAccount>> _getAccountsFuture;
  bool _isFirstRendering = true;
  bool _isShow = false;

  @override
  void initState() {
    super.initState();
    _getAccountsFuture = _accountService.getAccounts(defaultRequestAccountsArgs);
  }

  void updateAccounts(RequestAccounts args) {
    setState(() {
      _getAccountsFuture = _accountService.getAccounts(args);
    });
  }

  Future<void> pressCreateAccount(List<ResponseAccount> accounts) async {
    final result = await Navigator.of(context).pushNamed(
      "/create_account",
      arguments: CreateAccountPageArgs(isAccountsEmpty: accounts.isEmpty),
    );

    if (result == true) {
      updateAccounts(defaultRequestAccountsArgs);
    }
  }

  Widget getPageElement(List<ResponseAccount> accounts) {
    return Column(
      children: [
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            setState(() {
              _isShow = !_isShow;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            child: Row(
              children: [
                const Text(
                  "내 계좌 목록",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5),
                Icon(
                  _isShow ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  size: 22,
                ),
                const Spacer(),
                _isShow
                    ? GestureDetector(
                        onTap: () => SortAccountsDialog.show(context, updateCallback: updateAccounts),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: quickButtonDecoration,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.sort, size: 15),
                              Text("계좌 정렬"),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _isShow
            ? Column(
                children: (() {
                  if (accounts.isNotEmpty && accounts.length >= 5) {
                    return accounts
                        .map((account) => AccountItemWidget(
                              account: account,
                              updateCallback: () => updateAccounts(defaultRequestAccountsArgs),
                            ))
                        .toList();
                  } else if (accounts.isNotEmpty && accounts.length <= 4) {
                    return [
                      ...accounts.map((account) => AccountItemWidget(
                            account: account,
                            updateCallback: () => updateAccounts(defaultRequestAccountsArgs),
                          )),
                      CommonButtonBarWidget(
                        icon: Icons.account_balance_outlined,
                        title: "계좌 등록하기",
                        pressCallback: () => pressCreateAccount(accounts),
                      ),
                    ];
                  } else {
                    return [
                      const SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              size: 45,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "현재 등록된 계좌가 없습니다.",
                              style: TextStyle(
                                color: Color.fromARGB(255, 70, 70, 70),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonButtonBarWidget(
                        icon: Icons.account_balance_outlined,
                        title: "계좌 등록하기",
                        pressCallback: () => pressCreateAccount(accounts),
                      )
                    ];
                  }
                })(),
              )
            : const SizedBox.shrink(),
        SizedBox(height: _isShow ? 10 : 0),
        const CommonBorder(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstRendering
        ? Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstRendering = false);
            return getPageElement(widget.accounts);
          })
        : (() {
            return FutureBuilder(
              future: _getAccountsFuture,
              builder: (BuildContext context, AsyncSnapshot<List<ResponseAccount>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      SizedBox(height: 30),
                      LoadingHandlerWidget(title: "계좌 리스트 불러오기"),
                    ],
                  );
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  if (error is ConnectionError) {
                    return NetworkErrorHandlerWidget(reconnectCallback: () {
                      setState(() {
                        _getAccountsFuture = _accountService.getAccounts(defaultRequestAccountsArgs);
                      });
                    });
                  } else if (error is DioFailError) {
                    return const InternalServerErrorHandlerWidget();
                  } else {
                    return Center(child: Text("$error"));
                  }
                } else {
                  return getPageElement(snapshot.data!);
                }
              },
            );
          })();
  }
}
