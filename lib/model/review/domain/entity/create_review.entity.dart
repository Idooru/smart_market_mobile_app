import 'package:smart_market/model/review/domain/entity/review_form.entity.dart';

class RequestCreateReview extends ReviewForm {
  const RequestCreateReview({
    required super.productId,
    required super.content,
    required super.starRateScore,
    required super.reviewImages,
    required super.reviewVideos,
  });
}
