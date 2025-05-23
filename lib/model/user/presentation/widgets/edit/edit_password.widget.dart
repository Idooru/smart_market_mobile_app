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

class EditPasswordWidget extends StatefulWidget {
  final bool isLastWidget;

  const EditPasswordWidget({
    super.key,
    this.isLastWidget = false,
  });

  @override
  State<EditPasswordWidget> createState() => EditPasswordWidgetState();
}

class EditPasswordWidgetState extends EditWidgetState<EditPasswordWidget> with InputWidget, NetWorkHandler implements EditDetector {
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _newMatchPasswordFocusNode = FocusNode();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController matchPasswordController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditUserColumnProvider _provider;

  bool _isValid = false;
  String _errorMessage = "";

  @override
  FocusNode get focusNode => _newPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditUserColumnProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsPasswordValid(_isValid);
    });
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    matchPasswordController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(_) async {
    bool isValidLocal;
    String errorMessage;

    try {
      ResponseValidate result = await _userValidateService.validatePassword(
        newPassword: newPasswordController.text,
        matchPassword: matchPasswordController.text,
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

    _provider.setIsPasswordValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("비밀번호"),
        getEditWidget(
          TextField(
            obscureText: true,
            controller: newPasswordController,
            focusNode: _newPasswordFocusNode,
            textInputAction: TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock, color: _isValid ? Colors.green : Colors.red),
              hintText: "새 비밀번호",
            ),
          ),
        ),
        getEditWidget(
          TextField(
            obscureText: true,
            controller: matchPasswordController,
            focusNode: _newMatchPasswordFocusNode,
            textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock, color: _isValid ? Colors.green : Colors.red),
              hintText: "새 비밀번호 확인",
            ),
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
