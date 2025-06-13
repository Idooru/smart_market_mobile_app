import 'package:flutter/foundation.dart';

class EditReviewProvider extends ChangeNotifier {
  bool _isReviewTitleValid = false;
  bool _isReviewContentValid = false;

  bool get isReviewTitleValid => _isReviewTitleValid;
  bool get isReviewContentValid => _isReviewContentValid;

  void setIsReviewTitleValid(bool isReviewTitleValid) {
    _isReviewTitleValid = isReviewTitleValid;
    notifyListeners();
  }

  void setIsReviewContentValid(bool isReviewContentValid) {
    _isReviewContentValid = isReviewContentValid;
    notifyListeners();
  }

  void clearAll() {
    _isReviewTitleValid = false;
    _isReviewContentValid = false;
  }
}
