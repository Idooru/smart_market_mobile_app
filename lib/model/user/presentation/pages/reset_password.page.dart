import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/reset_password.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_email.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';

class ResetPasswordPageArgs {
  final String? email;

  const ResetPasswordPageArgs({this.email});
}

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  const ResetPasswordPage({
    super.key,
    this.email,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with NetWorkHandler {
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
      scaffoldMessenger.showSnackBar(getSnackBar("비밀번호를 초기화하였습니다."));
    } catch (err) {
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
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
            flexibleSpace: appBarColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FocusEditWidget<EditEmailWidgetState>(
                    editWidgetKey: _emailKey,
                    editWidget: EditEmailWidget(
                      key: _emailKey,
                      beforeEmail: widget.email,
                      hasDuplicateValidation: false,
                    ),
                  ),
                  EditPasswordWidget(key: _passwordKey, isLastWidget: true),
                  const SizedBox(height: 10),
                  getResetPasswordButton(provider),
                  const SizedBox(height: 10),
                  if (_hasError) getErrorMessageWidget(_errorMessage)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
