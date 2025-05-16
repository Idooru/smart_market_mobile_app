import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';

class EditPasswordWidget extends StatefulWidget {
  const EditPasswordWidget({super.key});

  @override
  State<EditPasswordWidget> createState() => EditPasswordWidgetState();
}

class EditPasswordWidgetState extends State<EditPasswordWidget> with EditWidget implements EditDetector {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController matchPasswordController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditProfileProvider _provider;

  bool _isValid = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditProfileProvider>();

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
    } on DioFailError catch (_) {
      isValidLocal = false;
      errorMessage = "서버 에러";
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
      children: [
        getEditWidget(
          TextField(
            obscureText: true,
            controller: newPasswordController,
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
            textInputAction: TextInputAction.done,
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
        if ((!_isValid) && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
