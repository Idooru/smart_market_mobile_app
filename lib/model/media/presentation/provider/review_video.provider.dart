import 'dart:io';

import 'package:smart_market/model/media/presentation/provider/media.provider.dart';

class ReviewVideoProvider extends MediaProvider {
  final int maxCount = 5;

  bool _isUploading = false;
  List<File> _reviewVideos = [];

  bool get isUploading => _isUploading;
  List<File> get reviewVideos => _reviewVideos;

  void setIsUploading(bool isUploading) {
    _isUploading = isUploading;
    notifyListeners();
  }

  void appendReviewVideos(List<File> newVideos) {
    _reviewVideos = [..._reviewVideos, ...newVideos];
    notifyListeners();
  }

  void removeReviewVideo(int index) {
    _reviewVideos = _reviewVideos..removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _reviewVideos.clear();
    _isUploading = false;
  }
}
