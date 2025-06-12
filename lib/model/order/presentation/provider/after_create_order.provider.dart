import 'package:flutter/cupertino.dart';

import '../../../cart/domain/entities/cart.entity.dart';

class ReviewCartItem {
  bool isChecked;
  final Cart cart;

  ReviewCartItem({
    required this.isChecked,
    required this.cart,
  });
}

class CompleteCreateOrderProvider extends ChangeNotifier {
  List<ReviewCartItem> _isCheckedList = [];

  List<ReviewCartItem> get isCheckedList => _isCheckedList;

  void appendIsCheckedList(ReviewCartItem item) {
    _isCheckedList = [..._isCheckedList, item];
    notifyListeners();
  }

  void modifyIsCheckedList(bool isChecked, int index) {
    ReviewCartItem item = _isCheckedList[index];
    item.isChecked = isChecked;
    _isCheckedList[index] = item;
    notifyListeners();
  }

  void clearAll() {
    _isCheckedList.clear();
  }
}
