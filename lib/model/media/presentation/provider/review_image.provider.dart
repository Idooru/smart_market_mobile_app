import 'dart:io';

import 'package:smart_market/model/media/presentation/provider/media.provider.dart';

class ReviewImageProvider extends MediaProvider {
  final int maxCount = 10;

  bool _isUploading = false;
  List<File> _reviewImages = [];

  bool get isUploading => _isUploading;
  List<File> get reviewImages => _reviewImages;

  void setIsUploading(bool isUploading) {
    _isUploading = isUploading;
    notifyListeners();
  }

  void appendReviewImages(List<File> newImages) {
    _reviewImages = [...reviewImages, ...newImages];
    notifyListeners();
  }

  void removeReviewImage(int index) {
    _reviewImages = _reviewImages..removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _reviewImages.clear();
    _isUploading = false;
  }
}
