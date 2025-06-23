import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';

class ReviewVideoProvider extends MediaProvider {
  final int maxCount = 5;

  bool _isUploading = false;
  List<FileSource> _reviewVideos = [];

  bool get isUploading => _isUploading;
  List<FileSource> get reviewVideos => _reviewVideos;

  void setIsUploading(bool isUploading) {
    _isUploading = isUploading;
    notifyListeners();
  }

  void appendReviewVideos(List<FileSource> newVideos) {
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
