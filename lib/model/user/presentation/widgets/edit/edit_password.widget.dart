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
  bool _isPasswordHide = true;
  bool _isMatchPasswordHide = true;
  List<String> _errorMessages = [];

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
    List<String> errorMessages;

    try {
      ResponseValidate result = await _userValidateService.validatePassword(
        newPassword: newPasswordController.text,
        matchPassword: matchPasswordController.text,
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

    _provider.setIsPasswordValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titile("비밀번호"),
        EditWidget(
          Row(
            children: [
              Expanded(
                child: TextField(
                  obscureText: _isPasswordHide,
                  controller: newPasswordController,
                  focusNode: _newPasswordFocusNode,
                  textInputAction: TextInputAction.next,
                  style: getInputStyle(),
                  onChanged: detectInput,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock, color: _isValid ? Colors.green : Colors.red),
                    hintText: "새 비밀번호",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordHide = !_isPasswordHide;
                    });
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.remove_red_eye, color: _isPasswordHide ? null : Colors.blue[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
        EditWidget(Row(
          children: [
            Expanded(
              child: TextField(
                obscureText: _isMatchPasswordHide,
                controller: matchPasswordController,
                focusNode: _newMatchPasswordFocusNode,
                textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
                style: getInputStyle(),
                onChanged: detectInput,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock, color: _isValid ? Colors.green : Colors.red),
                  hintText: "새 비밀번호 확인",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMatchPasswordHide = !_isMatchPasswordHide;
                  });
                },
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.remove_red_eye, color: _isMatchPasswordHide ? null : Colors.blue[700]),
                ),
              ),
            ),
          ],
        )),
        if (!_isValid && _errorMessages.isNotEmpty) ErrorArea(_errorMessages)
      ],
    );
  }
}
