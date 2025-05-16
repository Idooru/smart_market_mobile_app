import 'package:flutter/cupertino.dart';

class EditProfileProvider extends ChangeNotifier {
  bool _isNickNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneNumberValid = false;
  bool _isAddressValid = false;
  bool _isPasswordValid = false;

  bool get isNickNameValid => _isNickNameValid;
  bool get isEmailValid => _isEmailValid;
  bool get isPhoneNumberValid => _isPhoneNumberValid;
  bool get isAddressValid => _isAddressValid;
  bool get isPasswordValid => _isPasswordValid;

  void setIsNickNameValid(bool isNickNameValid) {
    _isNickNameValid = isNickNameValid;
    notifyListeners();
  }

  void setIsEmailValid(bool isEmailValid) {
    _isEmailValid = isEmailValid;
    notifyListeners();
  }

  void setIsPhoneNumberValid(bool isPhoneNumberValid) {
    _isPhoneNumberValid = isPhoneNumberValid;
    notifyListeners();
  }

  void setIsAddressValid(bool isAddressValid) {
    _isAddressValid = isAddressValid;
    notifyListeners();
  }

  void setIsPasswordValid(bool isPasswordValid) {
    _isPasswordValid = isPasswordValid;
    notifyListeners();
  }
}
