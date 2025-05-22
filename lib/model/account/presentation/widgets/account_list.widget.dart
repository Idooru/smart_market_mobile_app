import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/account/presentation/widgets/account_item.widget.dart';

class AccountListWidget extends StatefulWidget {
  const AccountListWidget({super.key});

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  final AccountService _accountService = locator<AccountService>();
  late Future<List<ResponseAccount>> _getAccountsFuture;

  @override
  void initState() {
    super.initState();

    updateAccounts();
  }

  void updateAccounts() {
    RequestAccounts args = const RequestAccounts(
      align: "DESC",
      column: "createdAt",
    );

    setState(() {
      _getAccountsFuture = _accountService.getAccounts(args);
    });
  }

  SizedBox getEmptyAccountMessage() {
    return const SizedBox(
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
    );
  }

  GestureDetector getSortAccountsButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 90,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 230, 230, 230),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.sort, size: 15),
            Text("계좌 정렬"),
          ],
        ),
      ),
    );
  }

  Future<void> pressCreateAccount() async {
    final result = await Navigator.of(context).pushNamed("/create_account");

    if (result == true) {
      updateAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          DioFailError err = snapshot.error as DioFailError;
          if (err.message == "none connection") {
            return Column(
              children: [
                const SizedBox(height: 25),
                NetworkErrorHandlerWidget(reconnectCallback: () {
                  setState(() {
                    RequestAccounts args = const RequestAccounts(
                      align: "DESC",
                      column: "createdAt",
                    );
                    _getAccountsFuture = _accountService.getAccounts(args);
                  });
                }),
                const SizedBox(height: 25),
              ],
            );
          } else {
            return const Column(
              children: [
                SizedBox(height: 25),
                InternalServerErrorHandlerWidget(),
                SizedBox(height: 25),
              ],
            );
          }
        } else if (snapshot.hasData) {
          List<ResponseAccount> accounts = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    "내 계좌 목록",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  getSortAccountsButton(),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: (() {
                  if (accounts.isNotEmpty) {
                    return [
                      ...accounts.map((account) => AccountItemWidget(
                            account: account,
                            updateCallback: updateAccounts,
                          )),
                      CommonButtonBarWidget(
                        icon: Icons.account_balance_outlined,
                        title: "계좌 등록하기",
                        pressCallback: pressCreateAccount,
                      ),
                    ];
                  } else if (accounts.length >= 5) {
                    return accounts
                        .map((account) => AccountItemWidget(
                              account: account,
                              updateCallback: updateAccounts,
                            ))
                        .toList();
                  } else {
                    return [
                      getEmptyAccountMessage(),
                      CommonButtonBarWidget(
                        icon: Icons.account_balance_outlined,
                        title: "계좌 등록하기",
                        pressCallback: pressCreateAccount,
                      )
                    ];
                  }
                })(),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
