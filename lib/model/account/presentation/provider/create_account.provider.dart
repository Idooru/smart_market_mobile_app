import 'package:flutter/material.dart';

class CreateAccountProvider extends ChangeNotifier {
  bool _isBankValid = false;
  bool _isAccountNumberValid = false;

  bool get isBankValid => _isBankValid;
  bool get isAccountNumberValid => _isAccountNumberValid;

  void setIsBankValid(bool isBankValid) {
    _isBankValid = isBankValid;
    notifyListeners();
  }

  void setIsAccountNumberVali(bool isAccountNumberValid) {
    _isAccountNumberValid = isAccountNumberValid;
    notifyListeners();
  }

  void clearAll() {
    _isBankValid = false;
    _isAccountNumberValid = false;
    notifyListeners();
  }
}
