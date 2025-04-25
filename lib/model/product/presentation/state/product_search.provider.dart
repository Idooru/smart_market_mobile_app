import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SearchMode {
  focused,
  searching,
  none,
}

class ProductSearchProvider extends ChangeNotifier {
  SearchMode _searchMode = SearchMode.none;
  List<String> _searchHistory = [];
  final TextEditingController _controller = TextEditingController();

  SearchMode get searchMode => _searchMode;
  List<String> get searchHistory => _searchHistory;
  TextEditingController get controller => _controller;
  String get search => _controller.text;

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

  void setSearch(String search) {
    _controller.text = search;
    notifyListeners();
  }

  void clearAll() {
    _searchMode = SearchMode.none;
    _searchHistory = [];
  }
}
