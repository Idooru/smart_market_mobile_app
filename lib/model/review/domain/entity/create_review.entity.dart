import 'package:smart_market/model/review/domain/entity/review.entity.dart';

class RequestCreateReview extends ReviewForm {
  final String productId;

  const RequestCreateReview({
    required this.productId,
    required super.content,
    required super.starRateScore,
    required super.reviewImages,
    required super.reviewVideos,
  });
}
