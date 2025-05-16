import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';

class EditEmailWidget extends StatefulWidget {
  final String? beforeEmail;

  const EditEmailWidget({
    super.key,
    this.beforeEmail,
  });

  @override
  State<EditEmailWidget> createState() => EditEmailWidgetState();
}

class EditEmailWidgetState extends State<EditEmailWidget> with EditWidget implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditProfileProvider _provider;

  bool _isValid = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditProfileProvider>();

    if (widget.beforeEmail != null) emailController.text = widget.beforeEmail!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsEmailValid(_isValid);
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && emailController.text.isEmpty) {
        emailController.text = widget.beforeEmail!;
        setState(() {
          _isValid = true;
          _errorMessage = "";
        });

        _provider.setIsEmailValid(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(_) async {
    bool isValidLocal;
    String errorMessage;

    try {
      ResponseValidate result = await _userValidateService.validateEmail(
        beforeEmail: widget.beforeEmail,
        currentEmail: emailController.text,
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

    _provider.setIsEmailValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getEditWidget(
          TextField(
            focusNode: _focusNode,
            controller: emailController,
            textInputAction: TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.email, _isValid),
          ),
        ),
        if (!_isValid) getErrorArea(_errorMessage)
      ],
    );
  }
}
