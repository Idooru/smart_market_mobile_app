import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/throw_network_error.dart';
import 'package:smart_market/model/review/domain/entity/all_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/detail_review.entity.dart';
import 'package:smart_market/model/review/domain/repository/review.repository.dart';

import '../../../../core/common/data_state.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/service/review.service.dart';

class ReviewServiceImpl implements ReviewService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final ReviewRepository _reviewRepository = locator<ReviewRepository>();

  @override
  Future<void> createReview(RequestCreateReview args) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _reviewRepository.createReview(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<List<ResponseAllReview>> fetchReviews(RequestAllReviews args) async {
    String? accessToken = _db.getString("access-token");
    DataState<List<ResponseAllReview>> dataState = await _reviewRepository.fetchReviews(accessToken!, args);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<ResponseDetailReview> fetchDetailReview(String reviewId) async {
    String? accessToken = _db.getString("access-token");
    DataState<ResponseDetailReview> dataState = await _reviewRepository.fetchDetailReview(accessToken!, reviewId);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }
}
