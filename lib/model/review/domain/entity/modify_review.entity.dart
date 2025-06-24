import 'package:smart_market/model/review/domain/entity/review_form.entity.dart';

class RequestModifyReview extends ReviewForm {
  final String reviewId;

  const RequestModifyReview({
    required this.reviewId,
    required super.productId,
    required super.content,
    required super.starRateScore,
    required super.reviewImages,
    required super.reviewVideos,
  });
}
