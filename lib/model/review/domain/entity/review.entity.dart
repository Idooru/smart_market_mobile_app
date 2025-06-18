import 'dart:io';

class ReviewForm {
  final String title;
  final String content;
  final int starRateScore;
  final List<File> reviewImages;
  final List<File> reviewVideos;

  const ReviewForm({
    required this.title,
    required this.content,
    required this.starRateScore,
    required this.reviewImages,
    required this.reviewVideos,
  });
}
