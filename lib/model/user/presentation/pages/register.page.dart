import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_address.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_birth.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_email.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_gender.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_nickname.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_phonenumber.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_realname.widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserService _userService = locator<UserService>();
  final GlobalKey<EditRealNameWidgetState> _realNameKey = GlobalKey<EditRealNameWidgetState>();
  final GlobalKey<EditGenderWidgetState> _genderKey = GlobalKey<EditGenderWidgetState>();
  final GlobalKey<EditBirthWidgetState> _birthKey = GlobalKey<EditBirthWidgetState>();
  final GlobalKey<EditEmailWidgetState> _emailKey = GlobalKey<EditEmailWidgetState>();
  final GlobalKey<EditPasswordWidgetState> _passwordKey = GlobalKey<EditPasswordWidgetState>();
  final GlobalKey<EditNickNameWidgetState> _nickNameKey = GlobalKey<EditNickNameWidgetState>();
  final GlobalKey<EditAddressWidgetState> _addressKey = GlobalKey<EditAddressWidgetState>();
  final GlobalKey<EditPhoneNumberWidgetState> _phoneNumberKey = GlobalKey<EditPhoneNumberWidgetState>();

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressRegister() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestRegister args = RequestRegister(
      realName: _realNameKey.currentState!.realNameController.text,
      gender: _genderKey.currentState!.selectedGender,
      birth: _birthKey.currentState!.selectedDate,
      nickName: _nickNameKey.currentState!.nickNameController.text,
      email: _emailKey.currentState!.emailController.text,
      password: _passwordKey.currentState!.matchPasswordController.text,
      phoneNumber: _phoneNumberKey.currentState!.phoneNumberController.text,
      address: _addressKey.currentState!.addressController.text,
      role: "client",
    );

    try {
      await _userService.register(args);
      navigator.pop();
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));
    } on DioFailError catch (_) {
      setState(() {
        _hasError = true;
        _errorMessage = "서버 에러";
      });
    }
  }

  GestureDetector getRegisterButton(EditProfileProvider provider) {
    bool isAllValid = provider.isRealNameValid &&
        provider.isGenderValid &&
        provider.isBirthBalid &&
        provider.isNickNameValid &&
        provider.isEmailValid &&
        provider.isPasswordValid &&
        provider.isPhoneNumberValid &&
        provider.isAddressValid;

    return GestureDetector(
      onTap: isAllValid ? pressRegister : () {},
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isAllValid ? Colors.blue : const Color.fromARGB(255, 190, 190, 190),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 19,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "회원가입 하기",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (BuildContext context, EditProfileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Register"),
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
                  const SizedBox(height: 5),
                  FocusEditWidget<EditRealNameWidgetState>(
                    editWidgetKey: _realNameKey,
                    editWidget: EditRealNameWidget(key: _realNameKey),
                  ),
                  EditGenderWidget(key: _genderKey),
                  EditBirthWidget(key: _birthKey),
                  EditEmailWidget(key: _emailKey),
                  EditPasswordWidget(key: _passwordKey),
                  EditNickNameWidget(key: _nickNameKey),
                  EditAddressWidget(key: _addressKey),
                  EditPhoneNumberWidget(key: _phoneNumberKey),
                  getRegisterButton(provider),
                  if (_hasError)
                    Center(
                        child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
