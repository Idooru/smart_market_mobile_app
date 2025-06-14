import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';
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

class _EditProfilePageState extends State<EditProfilePage> with NetWorkHandler {
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
      scaffoldMessenger.showSnackBar(getSnackBar("프로필을 수정하였습니다."));
    } catch (err) {
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  ConditionalButtonBarWidget getEditProfileButton(EditUserColumnProvider provider) {
    bool isAllValid = provider.isNickNameValid && provider.isEmailValid && provider.isPhoneNumberValid && provider.isAddressValid;

    return ConditionalButtonBarWidget(
      icon: Icons.person,
      title: "프로필 수정하기",
      isValid: isAllValid,
      pressCallback: pressEditProfile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditUserColumnProvider>(
      builder: (BuildContext context, EditUserColumnProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            centerTitle: false,
            flexibleSpace: Container(
              color: const Color.fromARGB(255, 240, 240, 240),
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
                  const SizedBox(height: 5),
                  getEditProfileButton(provider),
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
