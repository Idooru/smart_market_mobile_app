import 'package:flutter/cupertino.dart';

import '../../../account/domain/entities/account.entity.dart';
import '../../../cart/domain/entities/cart.entity.dart';

class CreateOrderProvider extends ChangeNotifier {
  bool _isDeliveryOptionValid = false;
  String _selectedDeliveryOption = "";
  List<Cart> _carts = [];
  int _cartTotalPrice = 0;
  List<ResponseAccount> _accounts = [];

  bool get isDeliveryOptionValid => _isDeliveryOptionValid;
  String get selectedDeliveryOption => _selectedDeliveryOption;
  List<Cart> get carts => _carts;
  int get cartTotalPrice => _cartTotalPrice;
  List<ResponseAccount> get accounts => _accounts;

  void setIsDeliveryOptionValid(bool isDeliveryOptionValid) {
    _isDeliveryOptionValid = isDeliveryOptionValid;
    notifyListeners();
  }

  void setSelectedDeliveryOption(String selectedDeliveryOption) {
    _selectedDeliveryOption = selectedDeliveryOption;
    notifyListeners();
  }

  void setCarts(List<Cart> carts) {
    _carts = carts;
    notifyListeners();
  }

  void setCartTotalPrice(int cartTotalPrice) {
    _cartTotalPrice = cartTotalPrice;
    notifyListeners();
  }

  void setAccounts(List<ResponseAccount> accounts) {
    _accounts = accounts;
    notifyListeners();
  }

  void clearAll() {
    _isDeliveryOptionValid = false;
    _selectedDeliveryOption = "";
    _carts = [];
    _cartTotalPrice = 0;
  }
}
