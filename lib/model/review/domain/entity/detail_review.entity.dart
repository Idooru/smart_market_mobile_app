import 'package:smart_market/core/utils/split_host_url.dart';

class ResponseDetailReview {
  final String id;
  final String content;
  final int starRateScore;
  final int countForModify;
  final List<String> imageUrls;
  final List<String> videoUrls;

  const ResponseDetailReview({
    required this.id,
    required this.content,
    required this.starRateScore,
    required this.countForModify,
    required this.imageUrls,
    required this.videoUrls,
  });

  factory ResponseDetailReview.fromJson(Map<String, dynamic> json) {
    return ResponseDetailReview(
      id: json["id"],
      content: json["content"],
      starRateScore: json["starRateScore"],
      countForModify: json["countForModify"],
      imageUrls: List<String>.from(json["imageUrls"]).map(splitHostUrl).toList(),
      videoUrls: List<String>.from(json["videoUrls"]).map(splitHostUrl).toList(),
    );
  }
}
