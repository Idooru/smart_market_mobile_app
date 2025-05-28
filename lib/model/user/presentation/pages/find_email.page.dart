import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/find_email.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/pages/reset_password.page.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_phonenumber.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_realname.widget.dart';

class FindEmailPage extends StatefulWidget {
  const FindEmailPage({super.key});

  @override
  State<FindEmailPage> createState() => _FindEmailPageState();
}

class _FindEmailPageState extends State<FindEmailPage> with NetWorkHandler {
  final UserService _userService = locator<UserService>();
  final GlobalKey<EditRealNameWidgetState> _realNameKey = GlobalKey<EditRealNameWidgetState>();
  final GlobalKey<EditPhoneNumberWidgetState> _phoneNumberKey = GlobalKey<EditPhoneNumberWidgetState>();

  bool _hasError = false;
  String _errorMessage = "";
  String _email = "";

  Future<void> pressFindEmail() async {
    RequestFindEmail args = RequestFindEmail(
      realName: _realNameKey.currentState!.realNameController.text,
      phoneNumber: _phoneNumberKey.currentState!.phoneNumberController.text,
    );

    try {
      String email = await _userService.findEmail(args);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _phoneNumberKey.currentState!.focusNode.unfocus();
      });

      setState(() {
        _hasError = false;
        _email = email;
      });
    } catch (err) {
      setState(() {
        _hasError = true;
        _email = "";
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  void pressResetPassword() {
    Navigator.of(context).pushNamed(
      "/reset_password",
      arguments: ResetPasswordPageArgs(email: _email),
    );
  }

  Widget getEmail() {
    if (_email.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 3, bottom: 5),
          child: Text(
            "찾은 이메일",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 230, 230, 230),
          ),
          child: Center(
            child: Text(_email),
          ),
        ),
        CommonButtonBarWidget(
          icon: Icons.lock,
          title: "비밀번호 초기화하기",
          pressCallback: pressResetPassword,
        ),
      ],
    );
  }

  ConditionalButtonBarWidget getFindEmailButton(EditUserColumnProvider provider) {
    bool isAllValid = provider.isRealNameValid && provider.isPhoneNumberValid;

    // 이메일을 한번 찾은 후 다시 이메일 찾기를 시도할 때 필드가 유효하지 않으면 이전에 찾은 이메일을 가려버림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (!isAllValid) _email = "";
      });
    });

    return ConditionalButtonBarWidget(
      icon: Icons.email,
      title: "이메일 찾기",
      isValid: isAllValid,
      pressCallback: pressFindEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditUserColumnProvider>(
      builder: (BuildContext context, EditUserColumnProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Find Email"),
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
                  FocusEditWidget(
                    editWidgetKey: _realNameKey,
                    editWidget: EditRealNameWidget(key: _realNameKey),
                  ),
                  EditPhoneNumberWidget(
                    key: _phoneNumberKey,
                    isLastWidget: true,
                    hasDuplicateValidation: false,
                  ),
                  getFindEmailButton(provider),
                  const SizedBox(height: 10),
                  if (_hasError) getErrorMessageWidget(_errorMessage),
                  getEmail(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
