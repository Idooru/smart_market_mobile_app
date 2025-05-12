import 'package:flutter/material.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';

class ProductFilteredProvider extends ChangeNotifier {
  List<ResponseSearchProduct> _products = [];
  bool _isFiltered = false;
  bool _isCreatedAtChanged = false;
  bool _isNameChanged = false;
  bool _isPriceChanged = false;
  bool _isAverageScoreChanged = false;
  bool _isReviewChanged = false;
  bool _isCategoryChanged = false;

  List<ResponseSearchProduct> get products => _products;
  bool get isFiltered => _isFiltered;
  bool get isCreatedAtFiltered => _isCreatedAtChanged;
  bool get isNameFiltered => _isNameChanged;
  bool get isPriceFiltered => _isPriceChanged;
  bool get isAverageScoreFiltered => _isAverageScoreChanged;
  bool get isReviewFiltered => _isReviewChanged;
  bool get isCategoryFiltered => _isCategoryChanged;

  void setIsFiltered(bool isFiltered) {
    _isFiltered = isFiltered;
    notifyListeners();
  }

  void setProducts(List<ResponseSearchProduct> products) {
    _products = products;
    notifyListeners();
  }

  void setColumnChanged(String column) {
    if (column == "createdAt") {
      _isCreatedAtChanged = true;
    } else if (column == "name") {
      _isNameChanged = true;
    } else if (column == "price") {
      _isPriceChanged = true;
    } else if (column == "review") {
      _isReviewChanged = true;
    } else if (column == "score") {
      _isAverageScoreChanged = true;
    }

    notifyListeners();
  }

  void setCategoryChanged(bool isCategoryChanged) {
    _isCategoryChanged = isCategoryChanged;
    notifyListeners();
  }

  void clearChanged() {
    _isFiltered = false;
    _isCreatedAtChanged = false;
    _isNameChanged = false;
    _isPriceChanged = false;
    _isAverageScoreChanged = false;
    _isReviewChanged = false;
    _isCategoryChanged = false;
  }

  void clearAll() {
    _products = [];
    _isFiltered = false;
    _isNameChanged = false;
    _isPriceChanged = false;
    _isAverageScoreChanged = false;
    _isCategoryChanged = false;
    _isCreatedAtChanged = false;
    _isReviewChanged = false;
    notifyListeners();
  }
}
