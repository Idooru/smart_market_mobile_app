import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/core/widgets/dialog/handle_network_error.dialog.dart';
import 'package:smart_market/model/user/domain/entities/register.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_address.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_birth.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_email.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_gender.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_nickname.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_password.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_phonenumber.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_realname.widget.dart';

import '../../../../core/utils/get_snackbar.dart';
import '../../../../core/widgets/dialog/loading_dialog.dart';

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

  void pressRegister() {
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

    LoadingDialog.show(context, title: "회원 가입 중..");

    _userService.register(args).then((_) {
      navigator.popUntil(ModalRoute.withName("/login"));
      scaffoldMessenger.showSnackBar(getSnackBar('회원가입이 완료되었습니다.'));
    }).catchError((err) {
      navigator.pop();
      HandleNetworkErrorDialog.show(context, err);
    });
  }

  ConditionalButtonBarWidget getRegisterButton(EditUserColumnProvider provider) {
    bool isAllValid = provider.isRealNameValid &&
        provider.isGenderValid &&
        provider.isBirthBalid &&
        provider.isNickNameValid &&
        provider.isEmailValid &&
        provider.isPasswordValid &&
        provider.isPhoneNumberValid &&
        provider.isAddressValid;

    return ConditionalButtonBarWidget(
      icon: Icons.person,
      backgroundColor: Colors.red,
      title: "회원가입 하기",
      isValid: isAllValid,
      pressCallback: pressRegister,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditUserColumnProvider>(
      builder: (BuildContext context, EditUserColumnProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Register"),
            centerTitle: false,
            flexibleSpace: appBarColor,
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
                  EditPhoneNumberWidget(key: _phoneNumberKey, isLastWidget: true),
                  const SizedBox(height: 10),
                  getRegisterButton(provider),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
