import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/custom_scrollbar.widget.dart';
import 'package:smart_market/model/account/common/const/default_request_accounts_args.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_button_bar.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../domain/entities/account.entity.dart';
import '../../domain/service/account.service.dart';
import '../dialog/sort_account.dialog.dart';
import '../widgets/account_item.widget.dart';
import 'create_account.page.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountsPage> {
  final AccountService _accountService = locator<AccountService>();
  final ScrollController controller = ScrollController();
  late Future<List<ResponseAccount>> _getAccountsFuture;

  bool _hasFilterButton = false;
  bool _hasCreateAccountButton = true;

  @override
  void initState() {
    super.initState();
    _getAccountsFuture = initOrdersPage();
  }

  Future<List<ResponseAccount>> initOrdersPage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    return _accountService.fetchAccounts(defaultRequestAccountsArgs);
  }

  void updateHasFilterButton(bool value) {
    if (_hasFilterButton == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasFilterButton = value;
      });
    });
  }

  void updateHasCreateAccountButton(bool value) {
    if (_hasCreateAccountButton == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasCreateAccountButton = value;
      });
    });
  }

  void updateAccounts(RequestAccounts args) {
    setState(() {
      _getAccountsFuture = _accountService.fetchAccounts(args);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ResponseAccount>>(
        future: _getAccountsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<ResponseAccount>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "계좌 리스트 불러오기");
          } else if (snapshot.hasError) {
            updateHasFilterButton(false);
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                updateAccounts(defaultRequestAccountsArgs);
              });
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget();
            } else {
              return Center(child: Text("$error"));
            }
          } else {
            List<ResponseAccount> accounts = snapshot.data!;
            updateHasFilterButton(accounts.isNotEmpty);
            return Scaffold(
              appBar: AppBar(
                title: const Text("My accounts"),
                centerTitle: false,
                flexibleSpace: appBarColor,
                actions: [
                  _hasFilterButton
                      ? IconButton(
                          onPressed: () => SortAccountsDialog.show(context, updateCallback: updateAccounts),
                          icon: const Icon(Icons.tune, color: Colors.black),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: CustomScrollbarWidget(
                      scrollController: controller,
                      childWidget: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: controller.hasClients ? 13 : 10,
                        ),
                        child: accounts.isEmpty
                            ? const Center(
                                child: Text(
                                  "현재 등록된 계좌가 없습니다.",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                controller: controller,
                                child: Column(
                                  children: (() {
                                    if (accounts.isNotEmpty && accounts.length >= 5) {
                                      updateHasCreateAccountButton(false);
                                      return accounts
                                          .map((account) => AccountItemWidget(
                                                account: account,
                                                updateCallback: () => updateAccounts(defaultRequestAccountsArgs),
                                              ))
                                          .toList();
                                    } else if (accounts.isNotEmpty && accounts.length <= 4) {
                                      updateHasCreateAccountButton(true);
                                      return accounts
                                          .map(
                                            (account) => AccountItemWidget(
                                              account: account,
                                              updateCallback: () => updateAccounts(defaultRequestAccountsArgs),
                                            ),
                                          )
                                          .toList();
                                    } else {
                                      return [const SizedBox.shrink()];
                                    }
                                  })(),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => _hasCreateAccountButton
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                            child: CommonButtonBarWidget(
                              icon: Icons.account_balance_outlined,
                              title: "계좌 등록하기",
                              pressCallback: () => pressCreateAccount(accounts),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
