import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
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
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("비밀번호를 수정하였습니다.")));
    } on DioFailError catch (_) {
      setState(() {
        _hasError = true;
        _errorMessage = "서버 에러";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (BuildContext context, EditProfileProvider provider, Widget? child) {
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
                  EditPasswordWidget(key: _passwordKey),
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
                  if (_hasError)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
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
