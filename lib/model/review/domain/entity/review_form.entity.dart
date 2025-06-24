import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';

class ReviewForm {
  final String productId;
  final String content;
  final int starRateScore;
  final List<FileSource> reviewImages;
  final List<FileSource> reviewVideos;

  const ReviewForm({
    required this.productId,
    required this.content,
    required this.starRateScore,
    required this.reviewImages,
    required this.reviewVideos,
  });
}
