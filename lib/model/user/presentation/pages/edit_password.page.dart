import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/core/widgets/dialog/handle_network_error.dialog.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';

import '../../../../core/widgets/dialog/loading_dialog.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final GlobalKey<EditPasswordWidgetState> _passwordKey = GlobalKey();
  final UserService _userService = locator<UserService>();

  void pressEditPassword() {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    String password = _passwordKey.currentState!.matchPasswordController.text;

    LoadingDialog.show(context, title: "비밀번호 수정 중..");

    _userService.modifyPassword(password).then((_) {
      navigator.pop();
      scaffoldMessenger.showSnackBar(getSnackBar("비밀번호를 수정하였습니다."));
    }).catchError((err) {
      navigator.pop();
      HandleNetworkErrorDialog.show(context, err);
    });
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
              color: const Color.fromARGB(255, 240, 240, 240),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
