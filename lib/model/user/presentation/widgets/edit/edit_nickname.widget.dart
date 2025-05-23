import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

class EditNickNameWidget extends StatefulWidget {
  final String? beforeNickName;
  final bool isLastWidget;
  final bool hasDuplicateValidation;

  const EditNickNameWidget({
    super.key,
    this.beforeNickName,
    this.isLastWidget = false,
    this.hasDuplicateValidation = true,
  });

  @override
  State<EditNickNameWidget> createState() => EditNickNameWidgetState();
}

class EditNickNameWidgetState extends EditWidgetState<EditNickNameWidget> with InputWidget, NetWorkHandler implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController nickNameController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditUserColumnProvider _provider;
  late bool _isValid;

  String _errorMessage = "";

  @override
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditUserColumnProvider>();
    _isValid = widget.beforeNickName != null;

    if (widget.beforeNickName != null) nickNameController.text = widget.beforeNickName!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsNickNameValid(_isValid);
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && nickNameController.text.isEmpty && widget.beforeNickName != null) {
        nickNameController.text = widget.beforeNickName!;
        setState(() {
          _isValid = true;
          _errorMessage = "";
        });

        _provider.setIsNickNameValid(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    nickNameController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(String? _) async {
    bool isValidLocal;
    String errorMessage;

    try {
      ResponseValidate result = await _userValidateService.validateNickName(
        beforeNickName: widget.beforeNickName,
        currentNickName: nickNameController.text,
        hasDuplicateValidation: widget.hasDuplicateValidation,
      );

      isValidLocal = result.isValidate;
      errorMessage = result.message;
    } on DioFailError catch (err) {
      isValidLocal = false;
      errorMessage = branchErrorMessage(err);
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessage = errorMessage;
    });

    _provider.setIsNickNameValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("닉네임"),
        getEditWidget(
          TextField(
            focusNode: _focusNode,
            controller: nickNameController,
            textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.tag, _isValid, "닉네임을 입력하세요."),
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
