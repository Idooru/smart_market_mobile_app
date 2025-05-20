import 'package:flutter/cupertino.dart';

class EditUserColumnProvider extends ChangeNotifier {
  bool _isRealNameValid = false;
  bool _isBirthValid = false;
  bool _isGenderValid = false;
  bool _isNickNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneNumberValid = false;
  bool _isAddressValid = false;
  bool _isPasswordValid = false;

  bool get isRealNameValid => _isRealNameValid;
  bool get isBirthBalid => _isBirthValid;
  bool get isGenderValid => _isGenderValid;
  bool get isNickNameValid => _isNickNameValid;
  bool get isEmailValid => _isEmailValid;
  bool get isPhoneNumberValid => _isPhoneNumberValid;
  bool get isAddressValid => _isAddressValid;
  bool get isPasswordValid => _isPasswordValid;

  void setIsRealNameValid(bool isRealNameValid) {
    _isRealNameValid = isRealNameValid;
    notifyListeners();
  }

  void setIsBirthValid(bool isBirthValid) {
    _isBirthValid = isBirthValid;
    notifyListeners();
  }

  void setIsGenderValid(bool isGenderValid) {
    _isGenderValid = isGenderValid;
    notifyListeners();
  }

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

  void clearAll() {
    _isRealNameValid = false;
    _isBirthValid = false;
    _isGenderValid = false;
    _isNickNameValid = false;
    _isEmailValid = false;
    _isPhoneNumberValid = false;
    _isAddressValid = false;
    _isPasswordValid = false;
    notifyListeners();
  }
}
