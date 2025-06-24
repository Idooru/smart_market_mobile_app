import 'package:smart_market/model/review/domain/entity/all_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/detail_review.entity.dart';

import '../../../../core/common/data_state.dart';
import '../entity/modify_review.entity.dart';

abstract interface class ReviewRepository {
  Future<DataState<void>> createReview(String accessToken, RequestCreateReview args);
  Future<DataState<List<ResponseAllReview>>> fetchReviews(String accessToken, RequestAllReviews args);
  Future<DataState<ResponseDetailReview>> fetchDetailReview(String accessToken, String reviewId);
  Future<DataState<void>> modifyReview(String accessToken, RequestModifyReview args);
}
