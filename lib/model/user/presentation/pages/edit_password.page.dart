import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> with NetWorkHandler {
  final GlobalKey<EditPasswordWidgetState> _passwordKey = GlobalKey();
  final UserService _userService = locator<UserService>();

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressEditPassword() async {
    try {
      NavigatorState navigator = Navigator.of(context);
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      String password = _passwordKey.currentState!.matchPasswordController.text;

      await _userService.modifyPassword(password);
      navigator.pop();
      scaffoldMessenger.showSnackBar(getSnackBar("비밀번호를 수정하였습니다."));
    } on DioFailError catch (err) {
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditUserColumnProvider>(
      builder: (BuildContext context, EditUserColumnProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Password"),
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
                  FocusEditWidget<EditPasswordWidgetState>(
                    editWidgetKey: _passwordKey,
                    editWidget: EditPasswordWidget(
                      key: _passwordKey,
                      isLastWidget: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: provider.isPasswordValid ? pressEditPassword : () {},
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: provider.isPasswordValid ? Colors.blue : const Color.fromARGB(255, 190, 190, 190),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 19,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "비밀번호 수정하기",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_hasError) getErrorMessageWidget(_errorMessage),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
