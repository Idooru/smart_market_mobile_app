import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLogined = false;

  bool get isLogined => _isLogined;

  void setIsLogined(bool isLogined) {
    _isLogined = isLogined;
    notifyListeners();
  }
}
