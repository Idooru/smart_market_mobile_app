import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_address.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_email.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_nickname.widget.dart';
import 'package:smart_market/model/user/presentation/widgets/edit/edit_phonenumber.widget.dart';

class EditProfilePageArgs {
  final ResponseProfile profile;

  const EditProfilePageArgs({required this.profile});
}

class EditProfilePage extends StatefulWidget {
  final ResponseProfile profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserService _userService = locator<UserService>();
  final GlobalKey<EditNickNameWidgetState> _nickNameKey = GlobalKey<EditNickNameWidgetState>();
  final GlobalKey<EditEmailWidgetState> _emailKey = GlobalKey<EditEmailWidgetState>();
  final GlobalKey<EditPhoneNumberWidgetState> _phoneNumberKey = GlobalKey<EditPhoneNumberWidgetState>();
  final GlobalKey<EditAddressWidgetState> _addressKey = GlobalKey<EditAddressWidgetState>();

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressEditProfile() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestUpdateProfile args = RequestUpdateProfile(
      nickName: _nickNameKey.currentState!.nickNameController.text,
      phoneNumber: _phoneNumberKey.currentState!.phoneNumberController.text,
      address: _addressKey.currentState!.addressController.text,
      email: _emailKey.currentState!.emailController.text,
    );

    try {
      await _userService.updateProfile(args);
      navigator.pop(true);
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("프로필을 수정하였습니다.")));
    } on DioFailError catch (_) {
      setState(() {
        _hasError = true;
        _errorMessage = "서버 에러";
      });
    }
  }

  GestureDetector getEditProfileButton(EditProfileProvider provider) {
    bool isAllValid = provider.isNickNameValid && provider.isEmailValid && provider.isPhoneNumberValid && provider.isAddressValid;

    return GestureDetector(
      onTap: isAllValid ? pressEditProfile : () {},
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
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
              "프로필 수정하기",
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

  GestureDetector getNavigateEditPasswordButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/edit_password");
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.amber,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (BuildContext context, EditProfileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            centerTitle: false,
            flexibleSpace: Container(
              color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  FocusEditWidget<EditNickNameWidgetState>(
                    editWidgetKey: _nickNameKey,
                    editWidget: EditNickNameWidget(beforeNickName: widget.profile.nickName, key: _nickNameKey),
                  ),
                  EditEmailWidget(beforeEmail: widget.profile.email, key: _emailKey),
                  EditPhoneNumberWidget(beforePhoneNumber: widget.profile.phoneNumber, key: _phoneNumberKey),
                  EditAddressWidget(beforeAddress: widget.profile.address, key: _addressKey, isLastWidget: true),
                  getEditProfileButton(provider),
                  if (_hasError)
                    Center(
                        child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )),
                  getNavigateEditPasswordButton()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
