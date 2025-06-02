import 'package:flutter/cupertino.dart';

class CreateOrderProvider extends ChangeNotifier {
  bool _isDeliveryOptionValid = false;

  bool get isDeliveryOptionValid => _isDeliveryOptionValid;

  void setIsDeliveryOptionValid(bool isDeliveryOptionValid) {
    _isDeliveryOptionValid = isDeliveryOptionValid;
    notifyListeners();
  }

  void clearAll() {
    _isDeliveryOptionValid = false;
    notifyListeners();
  }
}
