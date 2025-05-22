import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/reset_password.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_email.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final UserService _userService = locator<UserService>();
  final GlobalKey<EditEmailWidgetState> _emailKey = GlobalKey();
  final GlobalKey<EditPasswordWidgetState> _passwordKey = GlobalKey();

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressResetPassword() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestResetPassword args = RequestResetPassword(
      email: _emailKey.currentState!.emailController.text,
      password: _passwordKey.currentState!.matchPasswordController.text,
    );

    try {
      await _userService.resetPassword(args);
      navigator.popUntil(ModalRoute.withName("/login"));
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("비밀번호를 초기화하였습니다.")));
    } on DioFailError catch (err) {
      setState(() {
        _hasError = true;
        if (err.message == "none connection") {
          _errorMessage = "서버와 연결되지 않습니다.";
        } else if (err.response!.data["statusCode"] == 500) {
          _errorMessage = "서버 내부에서 에러가 발생하였습니다.";
        } else {
          _errorMessage = err.response!.data["reason"];
        }
      });
    }
  }

  ConditionalButtonBarWidget getResetPasswordButton(EditUserColumnProvider provider) {
    return ConditionalButtonBarWidget(
      icon: Icons.lock,
      title: "비밀번호 초기화하기",
      isValid: provider.isPasswordValid,
      pressCallback: pressResetPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditUserColumnProvider>(
      builder: (BuildContext context, EditUserColumnProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Reset Password"),
            centerTitle: false,
            flexibleSpace: Container(
              color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FocusEditWidget<EditEmailWidgetState>(
                    editWidgetKey: _emailKey,
                    editWidget: EditEmailWidget(key: _emailKey, hasDuplicateValidation: false),
                  ),
                  EditPasswordWidget(key: _passwordKey, isLastWidget: true),
                  getResetPasswordButton(provider),
                  const SizedBox(height: 10),
                  if (_hasError)
                    Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
