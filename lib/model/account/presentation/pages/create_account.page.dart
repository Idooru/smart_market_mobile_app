import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/account/domain/entities/create_account.entity.dart';
import 'package:smart_market/model/account/domain/service/account.service.dart';
import 'package:smart_market/model/account/presentation/provider/create_account.provider.dart';
import 'package:smart_market/model/account/presentation/widgets/deposit_balance.widget.dart';
import 'package:smart_market/model/account/presentation/widgets/edit_account_number.widget.dart';
import 'package:smart_market/model/account/presentation/widgets/select_bank.widget.dart';
import 'package:smart_market/model/account/presentation/widgets/set_main_account.widget.dart';

class CreateAccountPageArgs {
  final bool isAccountsEmpty;

  const CreateAccountPageArgs({required this.isAccountsEmpty});
}

class CreateAccountPage extends StatefulWidget {
  final bool isAccountsEmpty;

  const CreateAccountPage({
    super.key,
    required this.isAccountsEmpty,
  });

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> with NetWorkHandler {
  final AccountService _accountService = locator<AccountService>();
  final GlobalKey<SelectBankWidgetState> _bankKey = GlobalKey<SelectBankWidgetState>();
  final GlobalKey<EditAccountNumberWidgetState> _accountNumberKey = GlobalKey<EditAccountNumberWidgetState>();
  final GlobalKey<DepositBalanceWidgetState> _depositKey = GlobalKey<DepositBalanceWidgetState>();
  final GlobalKey<SetMainAccountWidgetState> _setMainAccountKey = GlobalKey<SetMainAccountWidgetState>();

  late CreateAccountProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<CreateAccountProvider>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.clearAll();
    });

    super.dispose();
  }

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressCreateAccount() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    String balanceText = _depositKey.currentState!.depositController.text;
    int balance = balanceText.isNotEmpty ? int.parse(balanceText) : 0;

    RequestCreateAccount args = RequestCreateAccount(
      bank: _bankKey.currentState!.selectedBank,
      accountNumber: _accountNumberKey.currentState!.accountNumberController.text,
      balance: balance,
      isMainAccount: _setMainAccountKey.currentState!.isChecked,
    );

    try {
      await _accountService.createAccount(args);
      navigator.pop(true);
      scaffoldMessenger.showSnackBar(getSnackBar('계좌 생성이 완료되었습니다.'));
    } on DioFailError catch (err) {
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  ConditionalButtonBarWidget getCreateAccountButton(CreateAccountProvider provider) {
    bool isAllValid = provider.isBankValid && provider.isAccountNumberValid;

    return ConditionalButtonBarWidget(
      icon: Icons.credit_card,
      title: "계좌 등록하기",
      isValid: isAllValid,
      pressCallback: pressCreateAccount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateAccountProvider>(
      builder: (BuildContext context, CreateAccountProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Account"),
            centerTitle: false,
            flexibleSpace: appBarColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SelectBankWidget(key: _bankKey),
                  EditAccountNumberWidget(key: _accountNumberKey),
                  DepositWidget(key: _depositKey),
                  SetMainAccountWidget(
                    key: _setMainAccountKey,
                    isAccountsEmpty: widget.isAccountsEmpty,
                  ),
                  const SizedBox(height: 10),
                  getCreateAccountButton(provider),
                  if (_hasError) getErrorMessageWidget(_errorMessage),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
