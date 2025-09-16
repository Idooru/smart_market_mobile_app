import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

class EditPhoneNumberWidget extends StatefulWidget {
  final String? beforePhoneNumber;
  final bool isLastWidget;
  final bool hasDuplicateValidation;

  const EditPhoneNumberWidget({
    super.key,
    this.beforePhoneNumber,
    this.isLastWidget = false,
    this.hasDuplicateValidation = true,
  });

  @override
  State<EditPhoneNumberWidget> createState() => EditPhoneNumberWidgetState();
}

class EditPhoneNumberWidgetState extends EditWidgetState<EditPhoneNumberWidget> with InputWidget, NetWorkHandler implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController phoneNumberController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditUserColumnProvider _provider;
  late bool _isValid;

  List<String> _errorMessages = [];

  @override
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _isValid = widget.beforePhoneNumber != null;
    _provider = context.read<EditUserColumnProvider>();

    if (widget.beforePhoneNumber != null) phoneNumberController.text = widget.beforePhoneNumber!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsPhoneNumberValid(_isValid);
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && phoneNumberController.text.isEmpty && widget.beforePhoneNumber != null) {
        phoneNumberController.text = widget.beforePhoneNumber!;
        setState(() {
          _isValid = true;
          _errorMessages = [];
        });

        _provider.setIsPhoneNumberValid(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(String? _) async {
    bool isValidLocal;
    List<String> errorMessages;

    try {
      ResponseValidate result = await _userValidateService.validatePhoneNumber(
        beforePhoneNumber: widget.beforePhoneNumber,
        currentPhoneNumber: phoneNumberController.text,
        hasDuplicateValidation: widget.hasDuplicateValidation,
      );

      isValidLocal = result.isValidate;
      errorMessages = result.errorMessages;
    } catch (err) {
      isValidLocal = false;
      errorMessages = [branchErrorMessage(err)];
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessages = errorMessages;
    });

    _provider.setIsPhoneNumberValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titile("전화번호"),
        EditWidget(
          TextField(
            focusNode: _focusNode,
            controller: phoneNumberController,
            textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
            style: getInputStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.phone, _isValid, "전화번호를 입력하세요."),
          ),
        ),
        if (!_isValid && _errorMessages.isNotEmpty) ErrorArea(_errorMessages),
      ],
    );
  }
}
