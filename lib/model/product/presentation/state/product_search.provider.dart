import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';

enum SearchMode {
  focused,
  searching,
  none,
}

enum SearchProductFail {
  none,
  socketException,
  internalServerException,
}

class ProductSearchProvider extends ChangeNotifier {
  SearchMode _searchMode = SearchMode.focused;
  List<String> _searchHistory = [];
  bool _isSetHistory = true;
  List<ResponseSearchProduct> _products = [];
  bool _isSuccessSetProducts = false;
  SearchProductFail _fail = SearchProductFail.none;
  final TextEditingController _controller = TextEditingController();

  SearchMode get searchMode => _searchMode;
  List<String> get searchHistory => _searchHistory;
  bool get isSetHistory => _isSetHistory;
  bool get isSuccessSetProducts => _isSuccessSetProducts;
  List<ResponseSearchProduct> get products => _products;
  SearchProductFail get fail => _fail;
  TextEditingController get controller => _controller;
  String get keyword => _controller.text;

  void setSearchMode(SearchMode mode) {
    _searchMode = mode;
    notifyListeners();
  }

  void appendHistory(String history) {
    _searchHistory = [..._searchHistory, history];
    notifyListeners();
  }

  void removeHistory(int index) {
    _searchHistory.removeAt(index);
    notifyListeners();
  }

  void turnOnHistory() {
    _isSetHistory = true;
    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    _isSetHistory = false;
    notifyListeners();
  }

  void setKeyword(String keyword) {
    _controller.text = keyword;
    notifyListeners();
  }

  void setProducts(List<ResponseSearchProduct> products) {
    _isSuccessSetProducts = true;
    _products = products;
    notifyListeners();
  }

  void setFail(SearchProductFail fail) {
    _fail = fail;
    notifyListeners();
  }

  void clearAll() {
    _searchMode = SearchMode.none;
    _searchHistory = [];
    _isSetHistory = true;
    _isSuccessSetProducts = false;
    _products = [];
    _fail = SearchProductFail.none;
  }
}
