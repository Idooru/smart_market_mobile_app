import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/account/domain/service/account_validate.service.dart';
import 'package:smart_market/model/account/presentation/provider/create_account.provider.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';

class EditAccountNumberWidget extends StatefulWidget {
  final bool isLastWidget;

  const EditAccountNumberWidget({
    super.key,
    this.isLastWidget = false,
  });

  @override
  State<EditAccountNumberWidget> createState() => EditAccountNumberWidgetState();
}

class EditAccountNumberWidgetState extends EditWidgetState<EditAccountNumberWidget> with InputWidget, NetWorkHandler implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController accountNumberController = TextEditingController();
  final AccountValidateService _accountValidateService = locator<AccountValidateService>();
  late CreateAccountProvider _provider;

  bool _isValid = false;
  List<String> _errorMessages = [];

  @override
  FocusNode get focusNode => throw UnimplementedError();

  @override
  void initState() {
    super.initState();
    _provider = context.read<CreateAccountProvider>();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(String? _) async {
    bool isValid;
    List<String> errorMessages;

    String accountNumber = accountNumberController.text;

    try {
      ResponseValidate result = await _accountValidateService.validateAccountNumber(accountNumber);

      isValid = result.isValidate;
      errorMessages = result.errorMessages;
    } on DioFailError catch (err) {
      isValid = false;
      errorMessages = [branchErrorMessage(err)];
    }

    setState(() {
      _isValid = isValid;
      _errorMessages = errorMessages;
    });

    _provider.setIsAccountNumberVali(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titile("계좌번호"),
        EditWidget(
          TextField(
            focusNode: _focusNode,
            controller: accountNumberController,
            textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
            style: getInputStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.credit_card, _isValid, "계좌번호를 입력하세요."),
          ),
        ),
        // if (!_isValid && _errorMessages.isNotEmpty) ErrorArea(_errorMessages)
      ],
    );
  }
}
