import 'package:smart_market/model/review/domain/entity/all_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/detail_review.entity.dart';

abstract interface class ReviewService {
  Future<void> createReview(RequestCreateReview args);
  Future<List<ResponseAllReview>> fetchReviews(RequestAllReviews args);
  Future<ResponseDetailReview> fetchDetailReview(String reviewId);
}
