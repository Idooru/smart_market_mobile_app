import 'dart:io';

class ReviewForm {
  final String content;
  final int starRateScore;
  final List<File> reviewImages;
  final List<File> reviewVideos;

  const ReviewForm({
    required this.content,
    required this.starRateScore,
    required this.reviewImages,
    required this.reviewVideos,
  });
}
