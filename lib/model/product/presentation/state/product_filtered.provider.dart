import 'package:flutter/material.dart';

class ProductFilteredProvider extends ChangeNotifier {
  bool isNameFiltered = false;
  bool isPriceFiltered = false;
  bool isAverageScoreFiltered = false;
  bool isCategoryFiltered = false;
  bool isCreatedAtFiltered = false;
  bool isReviewFiltered = false;

  void setFiltering(String column, bool isCategoryChecked) {
    if (column == "createdAt") {
      isCreatedAtFiltered = true;
    } else if (column == "name") {
      isNameFiltered = true;
    } else if (column == "price") {
      isPriceFiltered = true;
    } else if (column == "review") {
      isReviewFiltered = true;
    } else if (column == "score") {
      isAverageScoreFiltered = true;
    }

    isCategoryFiltered = isCategoryChecked;
    notifyListeners();
  }

  void clearFiltered() {
    isNameFiltered = false;
    isPriceFiltered = false;
    isAverageScoreFiltered = false;
    isCategoryFiltered = false;
    isCreatedAtFiltered = false;
    isReviewFiltered = false;
    notifyListeners();
  }
}
