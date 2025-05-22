import 'package:flutter/material.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/pages/reset_password.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with NetWorkHandler {
  final UserService _userService = locator<UserService>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidForm = false;
  bool _hasError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _emailFocusNode.requestFocus();
  }

  void detectInput(String _) {
    setState(() {
      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        _isValidForm = true;
      } else {
        _isValidForm = false;
      }
      _hasError = false;
    });
  }

  Future<void> pressLogin() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestLogin args = RequestLogin(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      await _userService.login(args);
      navigator.pop();
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('로그인이 완료되었습니다.')));
    } on DioFailError catch (err) {
      _passwordFocusNode.unfocus();
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  void pressRegister() {
    Navigator.of(context).pushNamed("/register");
  }

  void pressFindEmail() {
    Navigator.of(context).pushNamed("/find_email");
  }

  void pressResetPassword() {
    Navigator.of(context).pushNamed(
      "/reset_password",
      arguments: const ResetPasswordPageArgs(),
    );
  }

  ConditionalButtonBarWidget getLoginButton() {
    return ConditionalButtonBarWidget(
      backgroundColor: Colors.blueAccent,
      title: "로그인 하기",
      isValid: _isValidForm,
      pressCallback: pressLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 110,
        centerTitle: true,
        flexibleSpace: Container(
          color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(180, 240, 240, 240),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: detectInput,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                    hintText: "이메일을 입력하세요.",
                  ),
                  onSubmitted: (_) {
                    _emailFocusNode.unfocus();
                    _passwordFocusNode.requestFocus();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(180, 240, 240, 240),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  controller: _passwordController,
                  onChanged: detectInput,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                    hintText: "비밀번호를 입력하세요.",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_hasError) getErrorMessageWidget(_errorMessage),
              const SizedBox(height: 10),
              getLoginButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: pressRegister,
                    child: const Text(
                      "회원가입",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: pressFindEmail,
                    child: const Text(
                      "이메일 찾기",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: pressResetPassword,
                    child: const Text(
                      "비밀번호 초기화",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
