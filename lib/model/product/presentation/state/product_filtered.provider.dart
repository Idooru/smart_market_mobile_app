import 'package:flutter/material.dart';

class ProductFilteredProvider extends ChangeNotifier {
  bool isNameFiltered = false;
  bool isPriceFiltered = false;
  bool isAverageScoreFiltered = false;
  bool isCategoryFiltered = false;
  bool isCreatedAtFiltered = false;
  bool isReviewFiltered = false;

  void setNameFiltered(bool isCategorySelected) {
    isNameFiltered = true;

    if (isCategorySelected) {
      isCategorySelected = true;
    } else {
      isCategorySelected = false;
    }

    isPriceFiltered = false;
    isAverageScoreFiltered = false;
    isCreatedAtFiltered = false;
    isReviewFiltered = false;
    notifyListeners();
  }
}
