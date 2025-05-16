import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';

class EditNickNameWidget extends StatefulWidget {
  final String? beforeNickName;

  const EditNickNameWidget({
    super.key,
    this.beforeNickName,
  });

  @override
  State<EditNickNameWidget> createState() => EditNickNameWidgetState();
}

class EditNickNameWidgetState extends State<EditNickNameWidget> with EditWidget implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController nickNameController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditProfileProvider _provider;

  bool _isValid = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _provider = context.read<EditProfileProvider>();

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
      );

      isValidLocal = result.isValidate;
      errorMessage = result.message;
    } on DioFailError catch (_) {
      isValidLocal = false;
      errorMessage = "서버 에러";
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
      children: [
        getEditWidget(
          TextField(
            focusNode: _focusNode,
            controller: nickNameController,
            textInputAction: TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.tag, _isValid),
          ),
        ),
        if (!_isValid) getErrorArea(_errorMessage)
      ],
    );
  }
}
