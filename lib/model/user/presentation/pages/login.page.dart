import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestLogin args = RequestLogin(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      final state = context.findAncestorStateOfType<NavigationPageState>();
      await _userService.login(args);
      state?.tapBottomNavigator(0); // AllProductPage
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('로그인이 완료되었습니다.')));
    } on DioFailError catch (err) {
      _passwordFocusNode.unfocus();
      setState(() {
        _hasError = true;
        if (err.message == "none connection") {
          _errorMessage = "서버와 연결되지 않습니다.";
        } else if (err.response!.data["statusCode"] == 400) {
          _errorMessage = err.response!.data["reason"];
        } else if (err.response!.data["statusCode"] == 500) {
          _errorMessage = "서버 내부에서 에러가 발생하였습니다.";
        } else {
          _errorMessage = "원인 모를 에러가 발생하였습니다.";
        }
      });
    }
  }

  void pressRegister() {
    Navigator.of(context).pushNamed("/register");
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
              if (_hasError)
                Center(
                    child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                )),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _isValidForm ? pressLogin : () {},
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isValidForm ? Colors.blueAccent : const Color.fromARGB(180, 200, 200, 200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: _isValidForm ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "이메일 & 비밀번호 찾기",
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
